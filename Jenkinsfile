pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "jullyachenchi/group-i-django-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
        EC2_HOST = "34.228.26.17"
        EC2_USER = "ec2-user"
        APP_PORT = "8000"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Checking out code from repository...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo '🔨 Building Docker image...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo '📤 Pushing image to Docker Hub...'
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                echo '🚀 Deploying to EC2 instance...'
                script {
                    sshagent(['aws-ec2-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                                echo "🛑 Stopping old container..."
                                docker stop django-app || true
                                docker rm django-app || true
                                
                                echo "📥 Pulling new image..."
                                docker pull ${DOCKER_IMAGE}:latest
                                
                                echo "▶️  Starting new container..."
                                docker run -d -p ${APP_PORT}:${APP_PORT} --name django-app ${DOCKER_IMAGE}:latest
                                
                                echo "✅ Deployment complete!"
                                docker ps
                            '
                        """
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🌐 App is running at: http://${EC2_HOST}:${APP_PORT}"
        }
        failure {
            echo '❌ Pipeline failed!'
        }
        always {
            echo '🧹 Cleaning up local Docker images...'
            sh 'docker image prune -f'
        }
    }
}