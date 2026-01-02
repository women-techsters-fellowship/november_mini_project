pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        IMAGE_NAME = 'tbiruh1221/group-h-studybud'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'GROUP-H', url: 'git@github.com:women-techsters-fellowship/november_mini_project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
