pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'dockerhub-creds' 
        IMAGE_NAME = 'jemimahbyencitrimdan/nov_mini_project'
        IMAGE_TAG = 'group-J'
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
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Docker image built and pushed successfully."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}


