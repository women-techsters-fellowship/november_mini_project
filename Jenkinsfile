pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin"
        IMAGE = "naaasheley/november_mini_project"
        EC2_IP = "3.235.182.92"
        APP_PORT = "8000"
        DOCKER_CMD = "/usr/local/bin/docker"
    }

    stages {

        stage('Pre-flight Checks') {
            steps {
                echo "Checking Docker installation..."
                sh '$DOCKER_CMD --version'

                echo "Checking SSH access to EC2..."
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key', 
                        keyFileVariable: 'EC2_KEY', 
                        usernameVariable: 'EC2_USER'
                    )
                ]) {
                    sh "ssh -o StrictHostKeyChecking=no -i \$EC2_KEY \$EC2_USER@\$EC2_IP 'echo SSH connection successful!'"
                }
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'GROUP-B', url: 'https://github.com/women-techsters-fellowship/november_mini_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '$DOCKER_CMD build -t $IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub', 
                        usernameVariable: 'DOCKER_USER', 
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '$DOCKER_CMD logout || true'
                    sh 'echo $DOCKER_PASS | $DOCKER_CMD login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '$DOCKER_CMD push $IMAGE'
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key', 
                        keyFileVariable: 'EC2_KEY', 
                        usernameVariable: 'EC2_USER'
                    )
                ]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$EC2_KEY \$EC2_USER@\$EC2_IP \\
                        "docker stop groupb || true && \\
                         docker rm groupb || true && \\
                         docker pull ${IMAGE} && \\
                         docker run -d --name groupb -p ${APP_PORT}:${APP_PORT} ${IMAGE}"
                    """
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs and fix errors.'
        }
    }
}
