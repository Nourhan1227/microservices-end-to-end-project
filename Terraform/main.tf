provider "aws" {
  region=var.region # "us-east-1"
  # access_key=env.aws-access-key
  # secret_key=enaws-secret-key  
}

resource "aws_vpc" "my-vpc" {
     cidr_block=var.myvpc_cidr_block#"10.0.0.0/16"
     tags={
         Name= "my-vpc"
     }
}

resource "aws_subnet" "subnet-1" {
   vpc_id=aws_vpc.my-vpc.id
   cidr_block=var.subnet1_cidr_block#"10.0.0.0/24"
   availability_zone="us-east-1a"
   map_public_ip_on_launch = true

   tags={
         Name= "my-subnet-1"
     }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.subnet2_cidr_block    #"10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true


  tags = {
    Name = "subnet-2"
  }
}


resource "aws_internet_gateway" "my-igw" {
    vpc_id=aws_vpc.my-vpc.id
    tags= {
       Name= "my-igw"
    }

}



resource "aws_route_table" "my-route-table" {
    vpc_id=aws_vpc.my-vpc.id
    route {
       cidr_block="0.0.0.0/0"
       gateway_id=aws_internet_gateway.my-igw.id
    }
    tags = {
       Name = "my_route_table"
    }
}

resource "aws_route_table_association" "rt-subnet-association" {
   subnet_id= aws_subnet.subnet-1.id
   route_table_id=aws_route_table.my-route-table.id
}
resource "aws_route_table_association" "rt-subnet-association2" {
   subnet_id= aws_subnet.subnet-2.id
   route_table_id=aws_route_table.my-route-table.id
}

resource "aws_security_group" "eks-sec-grp" {
   name= "eks_sg"
   vpc_id = aws_vpc.my-vpc.id
   tags = {
       Name = "eks-sg"
    }

   ingress {
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     from_port   = 0
     to_port     = 5000 #for my app
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     from_port   = 8080
     to_port     = 8080
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
     from_port   = 0
     to_port     = 65535
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }


}
# ###########eks cluster roles
# #create iam role to have permission to control cluster
# #iam role named  eks_cluster_role

# resource "aws_iam_role" "eks_cluster_role" {
#   name = "eks-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = { Service = "eks.amazonaws.com" }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
# #after creating iam role 
# #attach policies to iam role
# #the first policy is named (mazonEKSClusterPolicy) to manage the eks cluster
# #ARn>>each resource has ARN to define it and make it unique
# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name  #bound the policy to iam role
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" #arn of this policy
# }
# #the second policy is named (AmazonEKSServicePolicy) #to communicate with aws services
# resource "aws_iam_role_policy_attachment" "eks_service_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
# }



# resource "aws_eks_cluster" "my-eks-cluster"{
#   name=var.cluster_name
#   role_arn = aws_iam_role.eks_cluster_role.arn #this is the iam role of eks cluster
#   vpc_config {
#     subnet_ids =[aws_subnet.subnet-1.id,aws_subnet.subnet-2.id]
#     security_group_ids = [aws_security_group.eks-sec-grp.id]
#   }

# }  


# ###########################################################################3
# #for worker node 
# #firstly create iam role of worker node and attach polices to it ,then create worker node and attach the iam role with
# #create iam role for worker node
# resource "aws_iam_role" "eks_worker_node_role" {
#   name = "eks-worker-node-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = { Service = "ec2.amazonaws.com" } #means that each ec2 is as one worker node
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
# #first policy (AmazonEKSWorkerNodePolicy) to make worker node work with eks cluster
# resource "aws_iam_role_policy_attachment" "worker_node_policy" {
#   role       = aws_iam_role.eks_worker_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }
# #sec policy  (AmazonEKS_CNI_Policy) for network config to pods created inside the worker nodes
# resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
#   role       = aws_iam_role.eks_worker_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }
# #3rd policy to give the node perm to access images on amazon ecr (AmazonEC2ContainerRegistryReadOnly)
# resource "aws_iam_role_policy_attachment" "ec2_read_only_policy" {
#   role       = aws_iam_role.eks_worker_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }
# #4rth policy (AmazonEC2FullAccess) give ec2 full access to control every thing in nodes
# resource "aws_iam_role_policy_attachment" "ec2_full_access_policy" {
#   role       = aws_iam_role.eks_worker_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  
# }
# #after creating iam role
# #create worker node
# resource "aws_eks_node_group" "my_eks_node_group" {
#   cluster_name    = aws_eks_cluster.my-eks-cluster.name
#   node_group_name = "eks-node-group"
#   node_role_arn   = aws_iam_role.eks_worker_node_role.arn
#   subnet_ids      = [aws_subnet.subnet-1.id,aws_subnet.subnet-2.id]

#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   instance_types = ["t2.micro"]

#   remote_access {
#     ec2_ssh_key = aws_key_pair.ssh_key.key_name
#     source_security_group_ids =[aws_security_group.eks-sec-grp.id]
#   }

#   tags = {
#     Name = "eks-node-group"
#   }
# }

# resource "aws_key_pair" "ssh_key" {
#   key_name   = "eks_ssh_key"
#   public_key = file(var.public_key_path) 
# }


# ########################################3
# #after enter the worker node on eks cluster you have to install k8s provider to communicate with node
# #to deploy app
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.my-eks-cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.my-eks-cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.my-eks-cluster.certificate_authority[0].data)
# }
