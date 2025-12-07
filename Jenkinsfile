pipeline {

  agent any

  environment {

    IMAGE = "<YOUR_DOCKERHUB_USERNAME>/nov_mini_project"

    EC2_HOST = "<EC2_PUBLIC_IP>"

    SSH_USER = "ubuntu"

    DOCKERHUB_CRED = "dockerhub-creds"

    EC2_SSH_CRED = "ec2-ssh-key"

  }

  stages {

    stage('Checkout') {

      steps { checkout scm }

    }

    stage('Build image') {

      steps {

        script {

          docker.withRegistry('', DOCKERHUB_CRED) {

            def built = docker.build("${IMAGE}", "--pull .")

            built.tag("${IMAGE}-${env.BUILD_NUMBER}")

            env.IMAGE_TAG = "${IMAGE}-${env.BUILD_NUMBER}"

          }

        }

      }

    }

    stage('Push image') {

      steps {

        script {

          docker.withRegistry('', DOCKERHUB_CRED) {

            docker.image("${IMAGE}").push()

            docker.image(env.IMAGE_TAG).push()

          }

        }

      }

    }

    stage('Deploy to EC2') {

      steps {

        sshagent (credentials: [EC2_SSH_CRED]) {

          sh """

            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${EC2_HOST} \\

            'docker pull ${IMAGE} && docker stop myapp || true && docker rm myapp || true && docker run -d --name myapp -p 80:8000 ${IMAGE}'

          """

        }

      }

    }

  }

  post {

    success { echo "Done" }

    failure { echo "Failed" }

  }

}

 
