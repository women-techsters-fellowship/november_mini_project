pipeline {
    agent any

    environment {
<<<<<<< HEAD
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        DOCKER_IMAGE          = 'susan22283/WTF_November_mini_project:latest'
        EC2_USER              = 'ubuntu'
        EC2_HOST              = '52.91.168.143'
        APP_PORT_HOST         = '8082'   // EC2 port
        APP_PORT_CONTAINER    = '8000'   // Django port
    }

    stages {

        stage('Checkout') {
    steps {
        sh '''
            mkdir -p ~/.ssh
            ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
        '''
        git branch: 'susan-demo', url: 'git@github.com:women-techsters-fellowship/november_mini_project.git'
    }   
    }
=======
        DOCKER_HUB_CREDENTIALS = 'dockerhub-creds'  
        DOCKER_IMAGE = 'jemimahbyencitrimdan/nov_mini_project:group-J' 
        EC2_HOST = credentials("EC2_HOST")
        SSH_CREDENTIALS = credentials("EC2_KEY")       
        APP_PORT = '8000'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'GROUP-J',
                    url: 'https://github.com/women-techsters-fellowship/november_mini_project.git'
            }
        }
>>>>>>> 5946a79babf25fecdae3664edda982ca1bbece89

        stage('Build Docker Image') {
            steps {
                script {
<<<<<<< HEAD
                    docker.build("${DOCKER_IMAGE}")
=======
                    docker.build(DOCKER_IMAGE)
>>>>>>> 5946a79babf25fecdae3664edda982ca1bbece89
                }
            }
        }

<<<<<<< HEAD
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "dockerhub-creds") {
                        docker.image("${DOCKER_IMAGE}").push()
=======
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS,
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                            docker.image(DOCKER_IMAGE).push()
                        }
>>>>>>> 5946a79babf25fecdae3664edda982ca1bbece89
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
<<<<<<< HEAD
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '

                            # Install Docker if missing
                            if ! command -v docker &> /dev/null; then
                                sudo apt-get update
                                sudo apt-get install -y docker.io
                                sudo usermod -aG docker ubuntu
                            fi

                            # Pull latest image
                            sudo docker pull ${DOCKER_IMAGE}

                            # Stop old container
                            sudo docker rm -f python_app || true

                            # Run new container with correct port mapping
                            sudo docker run -d --name python_app \\
                            -p ${APP_PORT_HOST}:${APP_PORT_CONTAINER} \\
                            ${DOCKER_IMAGE}

                        '
=======
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'EC2_KEY',
                        keyFileVariable: 'SSH_KEY_FILE',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_FILE} ${SSH_USER}@${EC2_HOST}  "
                        docker stop nov_app || true
                        docker rm nov_app || true
                        docker pull ${DOCKER_IMAGE}
                        docker run -d --name nov_app -p ${APP_PORT}:${APP_PORT} ${DOCKER_IMAGE}
                    "
>>>>>>> 5946a79babf25fecdae3664edda982ca1bbece89
                    """
                }
            }
        }
    }

    post {
        success {
<<<<<<< HEAD
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed."
=======
            echo 'CI/CD Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
>>>>>>> 5946a79babf25fecdae3664edda982ca1bbece89
        }
    }
}
