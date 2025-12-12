pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'  
        DOCKER_IMAGE = 'jemimahbyencitrimdan/nov_mini_project:group-J' 
        EC2_HOST = 'ubuntu@51.20.66.116'
        SSH_CREDENTIALS = 'EC2_KEYPAIR'       
        APP_PORT = '8000'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'GROUP-J',
                    url: 'https://github.com/women-techsters-fellowship/november_mini_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS,
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                            docker.image(DOCKER_IMAGE).push()
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    script {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_HOST} '
                            docker stop nov_app || true
                            docker rm nov_app || true
                            docker pull ${DOCKER_IMAGE}
                            docker run -d --name nov_app -p ${APP_PORT}:${APP_PORT} ${DOCKER_IMAGE}
                        '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}


