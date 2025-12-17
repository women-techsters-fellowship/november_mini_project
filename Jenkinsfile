pipeline {
    agent any

    environment {
        IMAGE_NAME = "Iveey/group-e-python-app"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'GROUP-E-AZURE', url: 'https://github.com/women-techsters-fellowship/november_mini_project.git'
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
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                sshagent(['azure-vm-ssh']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no azureuser@172.172.181.122 "
                        docker pull ${IMAGE_NAME}:${IMAGE_TAG} &&
                        docker stop myapp || true &&
                        docker rm group-e-python-app || true &&
                        docker run -d --name group-e-python-app -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}
                    "
                    '''
                }
            }
        }
    }
}

