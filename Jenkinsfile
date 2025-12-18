pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS  = 'dockerhub-creds'
        AWS_ACCESS_KEY_ID      = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        DOCKER_IMAGE           = 'syrha/november_project:latest'
        EC2_USER               = 'ubuntu'
        EC2_HOST               = credentials('ec2-host')
        APP_PORT_HOST          = credentials('ec2-app-port') // EC2 port
        APP_PORT_CONTAINER     = '8000'   // Django port
    }

    stages {

        stage('Checkout') {
            steps {
                sh '''
                    mkdir -p ~/.ssh
                    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
                '''
                git branch: 'GROUP-D',
                    url: 'git@github.com:women-techsters-fellowship/november_mini_project.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

                        docker buildx use amd64builder || \
                        docker buildx create --name amd64builder --use

                        docker buildx build \
                          --platform linux/amd64 \
                          -t syrha/november_project:latest \
                          --push .
                    '''
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

                            # Run new container
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
