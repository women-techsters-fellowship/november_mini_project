pipeline {
    agent any

    environment {
        IMAGE_NAME = "dockerhub254/group-h-python-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Using Docker Pipeline plugin - no permission issues!
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Using Docker Pipeline plugin with credentials
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    ),
                    string(credentialsId: 'EC2_HOST', variable: 'EC2_HOST')
                ]) {

                    sh """
                       # Fix SSH key permissions
			 chmod 600 "\${SSH_KEY}"

			# Execute deployment commands directly on EC2
                        ssh -o StrictHostKeyChecking=no -i "\${SSH_KEY"} "\${SSH_USER}@\${EC2_HOST}" "
                            echo "Starting deployment on EC2"

                            # Pull the new Docker image
                            docker pull dockerhub254/group-h-python-app:latest

                            # Stop and remove old container if it exists
                            docker stop app 2>/dev|| true
                            docker rm app 2>/dev|| true

                            # Run new container
                            docker run -d -p 8000:8000 --name app dockerhub254/group-h-python-app:latest
                            
                            # Clean up old images
                            docker image prune -f
                        "
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
