pipeline {
    agent any
   
    stages {
        stage("Checkout code") {
            steps {
                git branch: "GroupC",
                url: "https://github.com/women-techsters-fellowship/november_mini_project.git"
            }
        }
        stage("Build image and push") {

            steps {
                echo 'Building the image and pushing....'
                withCredentials([
                    usernamePassword(credentialsId:'docker_creds', usernameVariable:'DOCKER_USERNAME', passwordVariable:'DOCKER_PASSWORD')
                ]) {
                    sh'''
                        chmod 777 buildDockerScript.sh
                        ./buildDockerScript.sh
                    '''
                }
                
            }
        }
        stage("Deploy to EC2") {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'EC2_KEY', keyFileVariable: 'EC2_KEY'),
                    string(credentialsId: 'EC2_HOST', variable: 'EC2_HOST'),
                    usernamePassword(credentialsId: 'docker_creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
                ]) {
                    sh '''
                        chmod 600 $EC2_KEY
                        ssh -o StrictHostKeyChecking=no -i $EC2_KEY ubuntu@$EC2_HOST <<EOF
        
                    

                        echo "Connected to EC2"

                        # Install Docker if not installed
                        if ! command -v docker &> /dev/null; then
                            sudo apt update -y
                            sudo apt install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                            sudo usermod -aG docker ubuntu
                        fi

                        # Install Git if not installed
                        if ! command -v git &> /dev/null; then
                            sudo apt update -y
                            sudo apt install -y git
                        fi

                        # Remove old project folder to ensure fresh clone
                        if [ -d "/home/ubuntu/november_mini_project" ]; then
                            rm -rf "/home/ubuntu/november_mini_project"
                        fi


                        # Prepare persistent folder for SQLite
                        mkdir -p /home/ubuntu/sqlite

                        # Clone project repo if it doesn't exist, else pull latest
                        if [ ! -d "/home/ubuntu/november_mini_project" ]; then
                            git clone https://github.com/women-techsters-fellowship/november_mini_project.git "/home/ubuntu/november_mini_project"
                        fi

                        cd "/home/ubuntu/november_mini_project" || exit 1
                        git fetch origin
                        git checkout "GroupC"
                        git reset --hard origin/"GroupC"


                        # Copy db.sqlite3 to persistent folder
                        cp "/home/ubuntu/november_mini_project/db.sqlite3" /home/ubuntu/sqlite/db.sqlite3

                        # Set Docker credentials
                        export DOCKER_USERNAME="$DOCKER_USERNAME"
                        export DOCKER_PASSWORD="$DOCKER_PASSWORD"

                        # Run deploy script
                        bash ~/november_mini_project/deploy.sh
EOF
                    '''
                }
            }
    }

    }
}