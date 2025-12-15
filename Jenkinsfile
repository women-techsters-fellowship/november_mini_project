pipeline {
    agent any

    stages {
        stage("Checkout code") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/Group-A']],
                    extensions: [[$class: 'CloneOption', timeout: 300]],
                    userRemoteConfigs: [[
                        url: 'git@github.com:women-techsters-fellowship/november_mini_project.git',
                        credentialsId: 'github-ssh' 
                    ]]
                ])
            }
        }

        stage("Build Docker Images") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_creds', 
                                                usernameVariable: 'DOCKER_USERNAME', 
                                                passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        env.DOCKER_IMAGE = "${DOCKER_USERNAME}/ci_studybud_full_pipeline:v1"
                        
                        sh '''
                            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                            docker build -t $DOCKER_IMAGE -f Dockerfile .  
                            docker push $DOCKER_IMAGE
                            docker logout
                        '''
                    }
                }
            }
        }

        stage("Run on EC2") {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'EC2_KEY', keyFileVariable: 'SSH_KEY'),
                    string(credentialsId: 'EC2_HOST', variable: 'EC2_HOST'),
                    usernamePassword(credentialsId: 'docker_creds', 
                                     usernameVariable: 'DOCKER_USERNAME', 
                                     passwordVariable: 'DOCKER_PASSWORD')
                ]) {
                    script {
                        sh '''
                            chmod 600 "$SSH_KEY"
                            ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ubuntu@"$EC2_HOST" '
                                if ! command -v docker &> /dev/null; then
                                    sudo apt-get update
                                    sudo apt-get install -y docker.io
                                    sudo systemctl start docker
                                    sudo systemctl enable docker
                                fi  # THIS WAS MISSING - CLOSES THE IF STATEMENT

                                # Stop and remove existing container
                                docker stop studybud_container || true
                                docker rm studybud_container || true
                                
                                # Login to Docker Hub
                                docker login -u ''' + DOCKER_USERNAME + ''' -p ''' + DOCKER_PASSWORD + '''
                                
                                # Pull the latest image
                                docker pull ''' + DOCKER_USERNAME + '''/ci_studybud_full_pipeline:v1
                                
                                # Run the new container
                                docker run -d --name studybud_container -p 8000:8000 ''' + DOCKER_USERNAME + '''/ci_studybud_full_pipeline:v1
                                
                                # Logout from Docker Hub
                                docker logout
                            '
                        '''
                    }
                }
            }
        }
    }
}
