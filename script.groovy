// // def buildJar() {
// //     echo "building Jar file..."
// //     sh 'mvn package'
// // } 

// // def buildImage() {
// //     echo "building the docker image..."
// //     withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
// //     sh 'docker build -t ghanemovic/jenkins-task:jm-.0 .'
// //     sh "echo $PASS | docker login -u $USER --password-stdin"
// //     sh 'docker push ghanemovic/jenkins-task:jm-3.0'
// //     }
// // } 

// // def deployApp() {
// //     steps {
// //         echo 'deploying the application...'
// //     }
// // }

// // return this


// def buildNodeApp() {
//     echo "Building Node.js application..."
//     // Navigate to the subdirectory if necessary
//     dir('app') {  // Replace with your actual directory
//         sh 'npm install'
//     }
// }


// def buildImage() {
//     echo "Building the Docker image..."
//     withCredentials([usernamePassword(credentialsId: 'dockercred', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
//         sh "docker build -t ghanemovic/depi-final-project:latest ."
//         sh "echo $PASS| docker login -u $USER --password-stdin"
//         sh "docker push nourhan01289/pythonapp:latest"
//     }
// }

// return this

def initTerraform() {
    echo "Initializing Terraform..."
    sh 'terraform init'
}

def planTerraform() {
    echo "Planning Terraform..."
    sh 'terraform plan -out=tfplan'
}

def applyTerraform() {
    echo "Applying Terraform..."
    sh 'terraform apply -auto-approve tfplan'
}

// def destroyTerraform() {
//     echo "Destroying Terraform infrastructure..."
//     sh 'terraform destroy -auto-approve'
// }

return this
