pipeline {
    agent any

    environment {
        PROJECT_PATH = "/home/tabitha/Documents/PROJ/november_mini_project"
        DOCKER_IMAGE = "wtabitha/tabs-app-python"
        DOCKER_TAG = "latest"
        EC2_HOST = "ubuntu@35.175.108.76"
        APP_PORT_HOST = "8082"
        APP_PORT_CONTAINER = "8000"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'GROUP-F', url: 'git@github.com:women-techsters-fellowship/november_mini_project.git'
            }
        }   // <-- missing brace added here

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    """
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_HOST} '

                            # Install Docker if missing
                            if ! command -v docker &> /dev/null; then
                                sudo apt-get update
                                sudo apt-get install -y docker.io
                                sudo usermod -aG docker ubuntu
                            fi

                            # Pull latest image
                            sudo docker pull ${DOCKER_IMAGE}

                            # Stop old container
                            sudo docker rm -f python_app || true

                            # Run new container with correct port mapping
                            sudo docker run -d --name python_app \\
                                -p ${APP_PORT_HOST}:${APP_PORT_CONTAINER} \\
                                ${DOCKER_IMAGE}

                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}

