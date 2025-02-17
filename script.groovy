// // Install Dependencies (via the install_dep.sh script)
// // def installDependencies() {
// //     echo "Installing dependencies..."
// //     sh 'chmod +x install_dep.sh'  // Ensure the script is executable
// //     sh './install_dep.sh'  // Run the installation script
// // }

// // Build Docker Image and Push to Docker Hub
// def buildImage() {
//     echo "Building the Docker image..."
//     withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
//         sh 'docker build -t nourhan01289/pythonapp:latest .'  
//         sh "echo $PASS | docker login -u $USER --password-stdin"  
//         sh 'docker push nourhan01289/pythonapp:latest'  
//     }

// }
// // def deployApp(){
// //      steps{
// //         echo 'deploying the application...'
// //      }
// // }

// return this
// ###################################################################3

def initTerraform() {
    echo "Initializing Terraform..."
    sh 'terraform init'
}

def planTerraform() {
    echo "Planning Terraform..."
    sh 'terraform plan -out=tfplan'
}

// def applyTerraform() {
//     echo "Applying Terraform..."
//     sh 'terraform apply -auto-approve tfplan'
// }

// def destroyTerraform() {
//     echo "Destroying Terraform infrastructure..."
//     sh 'terraform destroy -auto-approve'
// }

return this
