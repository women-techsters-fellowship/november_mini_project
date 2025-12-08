pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        DOCKER_IMAGE          = 'susan22283/WTF_November_mini_project:latest'
        EC2_USER              = 'ubuntu'
        EC2_HOST              = '52.91.168.143'
        APP_PORT_HOST         = '8082'   // EC2 port
        APP_PORT_CONTAINER    = '8000'   // Django port
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'susan-demo', url: 'git@github.com:women-techsters-fellowship/november_mini_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "dockerhub-creds") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '

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
