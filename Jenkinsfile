pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'  
        DOCKER_IMAGE = 'jemimahbyencitrimdan/nov_mini_project:group-J' 
        EC2_HOST = credentials("EC2_HOST")
        SSH_CREDENTIALS = credentials("EC2_KEY")       
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
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'EC2_KEY',
                        keyFileVariable: 'SSH_KEY_FILE',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_FILE} ${SSH_USER}@${EC2_HOST} << EOF
                        docker stop nov_app || true
                        docker rm nov_app || true
                        docker pull ${DOCKER_IMAGE}
                        docker run -d --name nov_app -p ${APP_PORT}:${APP_PORT} ${DOCKER_IMAGE}
                    EOF
                    """
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
