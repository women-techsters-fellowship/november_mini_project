pipeline {
    agent any

    environment {
        DOCKERHUB_REPO  = 'susan22283/wtf_nov_project'
        CONTAINER_NAME  = 'wtf_nov_mini_project'
        EC2_HOST        = 'ubuntu@ec2-52-91-123-0.compute-1.amazonaws.com'
        IMAGE_TAG       = "build-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run tests') {
            steps {
                sh '''
                echo "Running tests... (currently no real tests)"
                '''
            }
        }

        stage('Build Docker image') {
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Push image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh '''
                    echo "Deploying to EC2..."

                    ssh -o StrictHostKeyChecking=no ${EC2_HOST} "
                        docker pull ${DOCKERHUB_REPO}:${IMAGE_TAG} &&
                        docker rm -f ${CONTAINER_NAME} || true &&
                        docker run -d --name ${CONTAINER_NAME} -p 8085:8000 ${DOCKERHUB_REPO}:${IMAGE_TAG}
                    "
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f || true'
        }
    }
}
