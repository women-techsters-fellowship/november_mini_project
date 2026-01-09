# November Mini Project

## Project Overview
This project demonstrates a complete CI/CD pipeline built in Jenkins that:
- Containerizes the Django application using Docker
- Automates builds and deployment
- Deploys the containerized app to AWS EC2 

## Prerequisites
Required Accounts
- [ ] GitHub account
- [ ] Docker Hub account (free tier)
- [ ] AWS account (free tier)

Required software
- **Windows users:** WSL2 (Windows Subsystem for Linux)
- **Mac/Linux users:** Terminal access
- **All users:**
  - Git
  - Docker Desktop
  - SSH client
  - Jenkins
  - Code editor

# Part 1: Setup & Dockerization
## Step 1: Clone the repo and create group branch
```
# Clone the project
git clone git@github.com:women-techsters-fellowship/november_mini_project.git
cd november_mini_project

# Create your group branch
git checkout -b GROUP-I  # Replace with your group name
```
## Step 2: modify the existing Dockerfile
The modified Dockerfile can be viewed [here](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-I/Dockerfile)

Multi-stage build was used in the Dockerfile:
- stage 1 compiles dependencies (needs build tools)
- stage 2 only copies the compiled packages and discards build tools

The result is a ~300mb smaller image

## Step 3: Build and test locally
```
# Build the image
docker build -t my-django-app:latest .

# Run the container
docker run -p 8000:8000 my-django-app:latest

# Test in browser
# Open: http://localhost:8000
```
# Part 2: Docker hub setup
## Step 1: create a docker hub account
- Visit https://hub.docker.com
- Sign up for a free account
- Note the username 

## Step 2: Push your image
Navigate to your local dev environment for this step.

Login to docker hub via your terminal

```
docker login
# Enter the one time key generated from the terminal
```

Tag your image
```
docker tag my-django-app:latest YOUR_USERNAME/group-i-django-app:latest
```
Push to docker hub
```
docker push YOUR_USERNAME/group-i-django-app:latest
```
Verify : check docker hub, you should see the image.

# Part 3: AWS EC2 Setup
## Step 1: Launch EC2 Instance
- Login to AWS Console → EC2 Dashboard
- Click "Launch Instance"

Configuration:
- Name: `django-deployment-server`
- AMI: Amazon linux (Free tier)
- Instance Type: `t2.micro`

Key Pair:
- Create new key pair
- Name: django-ec2-key
  - Type: RSA
  - Format: .pem
 > **_IMPORTANT:_** Download and save securely!

Security Group:
- Rule 1: `SSH (22)` - Source: My IP
- Rule 2: `Custom TCP (8000)` - Source: Anywhere (0.0.0.0/0)

Click 'launch instance'

## Step 2: Connect to ec2
### Windows/WSL
```
# Move key to .ssh folder
mkdir -p ~/.ssh
cp /mnt/c/Users/YOUR_USERNAME/Downloads/django-ec2-key.pem ~/.ssh/
chmod 400 ~/.ssh/django-ec2-key.pem

# Connect
ssh -i ~/.ssh/django-ec2-key.pem ec2-user@YOUR_EC2_PUBLIC_IP
```
### Mac/Linux
```
chmod 400 ~/Downloads/django-ec2-key.pem
ssh -i ~/Downloads/django-ec2-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

## Step 3: Install docker on ec2
```
# Update system
sudo apt update
sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Exit and reconnect for changes to take effect
exit

# Reconnect
ssh -i ~/.ssh/django-ec2-key.pem ec2-user@YOUR_EC2_PUBLIC_IP

# Verify Docker works
docker --version
docker ps
```

# Part 4: Jenkins setup with docker
## Step 1: Run Jenkins Container
```
# Create network and volume
docker volume create jenkins_home

# Run Jenkins
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add $(stat -c '%g' /var/run/docker.sock) \
  --restart unless-stopped \
  jenkins/jenkins:lts
  ```
  
## Step 2: Install docker in Jenkins container
  ```
  # Access Jenkins container
docker exec -it -u root jenkins bash

# Inside container, run:
apt-get update
apt-get install -y docker.io
usermod -aG docker jenkins
exit

# Restart Jenkins
docker restart jenkins
```

## Step 3: Initial Jenkins setup
1. Access Jenkins on http://localhost:8080
2. Get Admin password
```
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
3. Setup
  - Paste password
  - Install suggested plugins (wait 2-3 minutes)
  - Create admin user:
    - Username: `admin`
    - Password: (choose a secure password)
    - Full name: Your name
    - Email: your email
Click "Save and Continue" → "Start using Jenkins"
4. Install required plugins
  - Manage jenkins -> plugins -> available plugins
  - Search and install (if not installed):
    - SSH Agent
    - Docker pipeline
    - Git

## Step 4: Add credentials
#### A. Docker hub credentials
1. Manage Jenkins → Credentials → System → Global credentials
2. Click "Add Credentials"
3. Configure:
   -  Kind: `Username with password`
   -  Username: *Your Docker Hub username*
   -  Password: *Your Docker Hub password*
   -  ID: `docker-hub-credentials`
   -  Description: `Docker Hub Login`
4. Click "Create"

#### B. EC2 SSH key
1. Click "Add Credentials" again
2. Configure:
    - Kind: `SSH Username with private key`
    - ID: `aws-ec2-ssh-key`
    - Username: `ec2-user`
    - Private Key: Enter directly
        - Open your .pem file in a text editor
        - Copy EVERYTHING (including BEGIN/END lines)
        - Paste into Jenkins
    - Description: EC2 SSH Key
3. Click "Create"

# Part 5: Create the CI/CD pipeline
## Step 1: Create `Jenkinsfile`
In the project root, create `Jenkinsfile`

The contents of the file can be viewed [here](Jenkinsfile)

## Step 2: Commit and push
```
# Add files
git add Dockerfile Jenkinsfile


# Commit
git commit -m "Add CI/CD pipeline configuration"

# Push to your branch
git push origin GROUP-I
```
## Step 3: Create Jenkins pipeline job
On the Jenkins dashboard:
1. **Jenkins Dashboard** → **New Item**
2. **Name:** `django-deploy`
3. **Type:** Pipeline
4. Click **OK**

**Configure:**
- **General:**
  - ✅ GitHub project
  - Project URL: `https://github.com/women-techsters-fellowship/november_mini_project/`
  - **Pipeline:**
  - Definition: Pipeline script from SCM
  - SCM: Git
  - Repository URL: `https://github.com/women-techsters-fellowship/november_mini_project.git`
  - Branch Specifier: `*/GROUP-I`
  - Script Path: `Jenkinsfile`
5. Click **save**

# Part 6: Deploy
## Step 1: Run the pipeline
1. Click **"Build Now"**
2. Watch the build progress
3. Click on build #1 → **Console Output**

**Expected stages:**
- ✅ Checkout Code
- ✅ Build Docker Image (~2-3 minutes)
- ✅ Push to Docker Hub (~1 minute)
- ✅ Deploy to EC2 (~30 seconds)

## Step 2: Verify Deployment
**Visit:** `http://YOUR_EC2_IP:8000`

You should see your Django application running