def gv

pipeline {
    agent any
    // tools {
    //     python 'Python-3.11'  // from the tools configuration
    // }
    stages {
        stage("Init") {
            steps {
                script {
                    gv = load "script.groovy"  // Load external Groovy script
                }
            }
        }

        stage('Checkout Code') {
            steps {
                // Checkout code from your repo
                git branch: 'main', url: 'https://github.com/Nourhan1227/microservices-end-to-end-project.git'
            }
        }

        stage("Install Dependencies") {
            steps {
                script {
                    // Installing dependencies using the install_dep.sh script
                    gv.installDependencies()  // Custom method to handle install
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    // You can integrate a testing framework like PyTest here if needed
                    echo 'Running unit tests...'
                    // sh 'pytest tests/' // Uncomment if you have test files
                }
            }
        }

        stage("Build Image and Push to Docker Hub") {
            steps {
                script {
                    gv.buildImage()  // Build and push Docker image
                }
            }
        }

        stage("Deploy to Server") {
            steps {
                script {
                    gv.eployApp()
                    
                }
            }
        }
    }

    post {
        success {
            script {
                slackSend(channel: '#your-slack-channel', message: "Build succeeded: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
            }
        }
        failure {
            script {
                slackSend(channel: '#your-slack-channel', message: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
            }
        }
    }
}

// pipeline {
//     agent any

//     environment {
//         AWS_ACCESS_KEY_ID = credentials('aws-access-key')   // AWS credentials (stored in Jenkins)
//         AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
//     }

//     stages {
//         stage("Init") {
//             steps {
//                 script {
//                     gv = load "script.groovy"  // Load the Groovy script
//                 }
//             }
//         }

//         stage("Checkout Code") {
//             steps {
//                 git branch: 'main', url: 'https://github.com/Nourhan1227/microservice-end-to-end-project.git'
//             }
//         }

//         stage("Terraform Init") {
//             steps {
//                 script {
//                     gv.initTerraform()
//                 }
//             }
//         }

//         stage("Terraform Plan") {
//             steps {
//                 script {
//                     gv.planTerraform()
//                 }
//             }
//         }

//         stage("Terraform Apply") {
//             steps {
//                 script {
//                     gv.applyTerraform()
//                 }
//             }
//         }

//         // stage("Terraform Destroy (Optional)") {
//         //     when {
//         //         expression { return params.DESTROY_INFRA }  // Add a checkbox parameter in Jenkins UI
//         //     }
//         //     steps {
//         //         script {
//         //             gv.destroyTerraform()
//         //         }
//         //     }
//         // }
//     }

//     post {
//         success {
//             echo "Terraform pipeline completed successfully!"
//         }
//         failure {
//             echo "Terraform pipeline failed!"
//         }
//     }
// }
