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
                // Docker commands will run using host Docker
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'USERNAME',
                        passwordVariable: 'PASSWORD'
                    )
                ]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
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
                    sh '''
                        chmod 600 $SSH_KEY
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@$EC2_HOST << 'EOF'
                            echo "Connected to EC2"

                            # Pull the new Docker image
                            docker pull $IMAGE_NAME:$IMAGE_TAG

                            # Stop and remove old container if it exists
                            docker stop app || true
                            docker rm app || true

                            # Run new container
                            docker run -d -p 8000:8000 --name app $IMAGE_NAME:$IMAGE_TAG
                        EOF
                    '''
                }
            }
        }
    }
}

