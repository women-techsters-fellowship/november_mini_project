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
        // stage("Deploy to EC2") {
        //     steps {
        //         withCredentials([
        //             sshUserPrivateKey(credentialsId:'EC2_KEY', keyFileVariable:'EC2_KEY'),
        //             string(credentialsId:'EC2_HOST', variable:'EC2_HOST'),
        //             usernamePassword(credentialsId:'docker_creds', usernameVariable:'DOCKER_USERNAME', passwordVariable:'DOCKER_PASSWORD')
        //         ]) {
        //             sh'''
        //                 chmod 600 $EC2_KEY
        //                 ssh -o StrictHostKeyChecking=no -i $EC2_KEY ubuntu@$EC2_HOST <<EOF
        //                 echo "Connected to EC2"
        //                 export DOCKER_USERNAME="$DOCKER_USERNAME"
        //                 export DOCKER_PASSWORD="$DOCKER_PASSWORD"
        //                 cd /home/ubuntu/React-TodoList
        //                 bash ~/React-Todolist/deploy.sh
        //             EOF
        //             '''
        //         }
        //     }
        // }
    }
}