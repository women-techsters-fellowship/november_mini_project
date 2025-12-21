pipeline {
    agent any

    environment {
        IMAGE_NAME = "dockerhub254/group-h-python-app"
        IMAGE_TAG  = "latest"
        EC2_HOST   = credentials('EC2_HOST')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh '''
                      echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
                      docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                      ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST './deploy.sh'
                        docker pull $IMAGE_NAME:$IMAGE_TAG
                        docker stop app || true
                        docker rm app || true
                        docker run -d -p 8000:8000 --name app $IMAGE_NAME:$IMAGE_TAG
                      
                    """
                }
            }
        }
    }
}

