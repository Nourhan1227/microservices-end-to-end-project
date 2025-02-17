
// def gv

// pipeline {
//     agent any
//     tools {
//         nodejs 'Nodejs-22.9.0'  // from the tools configuration
//     }
//     stages {
//         stage("Init") {
//             steps {
//                 script {
//                     gv = load "script.groovy"  // Load external Groovy script
//                 }
//             }
//         }

//         stage('Checkout Code') {
//             steps {
//                 // Checkout code from your repo
//                 git branch: 'test', url: 'https://github.com/AhMed-GhaNem25/Final-DEPI-Project.git'
//             }
//         }
//         stage("Install Dependencies") {
//             steps {
//                 script {
//                     // Installing Node.js dependencies
//                     gv.buildNodeApp()  // Custom method to handle npm install and build
//                 }
//             }
//         }

//         // stage('Run Unit Tests') {
//         //     steps {
//         //         sh 'npx jest'
//         //     }
//         // }

//     stage('Parallel Tests') {
//         parallel {
//             stage('Unit Tests') {
//                 steps {
//                     sh 'npx jest'
//                 }
//             }
//         }
//     }
        
//         stage("Build Image and Push to Docker Hub") {
//             steps {
//                 script {
//                     gv.buildImage()  // Build and push Docker image
//                 }
//             }
//         }
//         stage('Run Ansible Playbook') {
//             steps {
//                 // Run the playbook and specify the private key and user
//                 sh '''
//                     ansible-playbook -i 54.204.216.90, \
//                     --user ec2-user \
//                     --private-key /var/jenkins_home/.ssh/Gh-test.pem \
//                     deploy-docker.yaml
//                 '''
//             }
//         }
//     }
    


//     post {
//         success {
//             script {
//                 slackSend(channel: '#depi-slack-channel', message: "Build succeeded: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
//             }
//         }
//         failure {
//             script {
//                 slackSend(channel: '#depi-slack-channel', message: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
//             }
//         }
//     }

// }
def gv  // Declare global variable

pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')   // AWS credentials (stored in Jenkins)
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage("Init") {
            steps {
                script {
                    gv = load "script.groovy"  // Load the Groovy script
                }
            }
        }

        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/Nourhan1227/microservice-end-to-end-project.git'
            }
        }

        stage("Terraform Init") {
            steps {
                script {
                    gv.initTerraform()
                }
            }
        }

        stage("Terraform Plan") {
            steps {
                script {
                    gv.planTerraform()
                }
            }
        }

        stage("Terraform Apply") {
            steps {
                script {
                    gv.applyTerraform()
                }
            }
        }

        // stage("Terraform Destroy (Optional)") {
        //     when {
        //         expression { return params.DESTROY_INFRA }  // Add a checkbox parameter in Jenkins UI
        //     }
        //     steps {
        //         script {
        //             gv.destroyTerraform()
        //         }
        //     }
        // }
    }

    post {
        success {
            echo "Terraform pipeline completed successfully!"
        }
        failure {
            echo "Terraform pipeline failed!"
        }
    }
}
