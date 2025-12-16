pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: "GROUP-F",
                    url: "https://github.com/women-techsters-fellowship/november_mini_project.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([
                    string(credentialsId: 'docker_image', variable: 'DOCKER_IMAGE')
                ]) {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:v1 .
                    """
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    string(credentialsId: 'docker_image', variable: 'DOCKER_IMAGE'),
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:v1
                        docker logout
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    string(credentialsId: 'docker_image', variable: 'DOCKER_IMAGE'),
                    string(credentialsId: 'app_port_host', variable: 'APP_PORT_HOST'),
                    string(credentialsId: 'app_port_container', variable: 'APP_PORT_CONTAINER'),
                    string(credentialsId: 'serverip', variable: 'EC2_IP'),
                    string(credentialsId: 'ec2-user', variable: 'EC2_USER')
                ]) {
                    sshagent(['ec2-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '

                                if ! command -v docker &> /dev/null; then
                                    sudo apt-get update
                                    sudo apt-get install -y docker.io
                                    sudo usermod -aG docker ${EC2_USER}
                                fi

                                sudo docker pull ${DOCKER_IMAGE}:v1

                                sudo docker rm -f python_app || true

                                sudo docker run -d --name python_app \\
                                    -p ${APP_PORT_HOST}:${APP_PORT_CONTAINER} \\
                                    ${DOCKER_IMAGE}:v1

                            '
                        """
                    }
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

