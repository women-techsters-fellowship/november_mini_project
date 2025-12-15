StudyBud Deployment Documentation (Group C)

Project: StudyBud
Group: Group C
Date: 13 Dec 2025

Live Application URL:
👉 http://98.92.250.22:9000

1. Project Overview

This document describes the complete CI/CD deployment process for the StudyBud application.
The deployment uses Jenkins, Docker, and AWS EC2 to automate building, packaging, and releasing the application.

The system supports persistent user data, allowing users to sign up, log in, and create posts without losing data during redeployments.

2. Architecture Summary

Source Control: GitHub

CI/CD Tool: Jenkins

Containerization: Docker

Server: AWS EC2 (Ubuntu 24.04 LTS)

Backend Framework: Django

Database: SQLite (persistent)

Branch Used: GroupC

3. Deployment Artifacts (Screenshots)

The following deployment components were implemented and are provided as screenshots for verification:

Dockerfile

Jenkinsfile

buildDockerScript.sh

deploy.sh

Django settings.py (ALLOWED_HOSTS)

Jenkins successful build UI

Live application running on EC2

4. Docker Image Configuration

The Dockerfile defines how the StudyBud application is containerized, including installing dependencies and configuring the Django runtime environment. We also refactored the Docker file using a multi-stage Docker build to reduce the size from 500MB+ to 200MB+ 

![Dockerfile Screenshot](https://github.com/user-attachments/assets/8ab432d8-08d9-4137-bbd2-2f689209bc51)


5. Jenkins Pipeline Setup

The Jenkinsfile defines the CI/CD pipeline stages, including source code checkout, Docker image build, Docker Hub push, and EC2 deployment.

<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 12 56 27 PM" src="https://github.com/user-attachments/assets/91ca33dd-9f3b-4e58-865f-e021afaadb14" />

<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 12 56 32 PM" src="https://github.com/user-attachments/assets/ca6279f6-4a9d-43d0-a039-41ac2119b1ea" />

<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 12 56 35 PM" src="https://github.com/user-attachments/assets/a6241e46-23d1-42eb-a656-7629cede10da" />



6. Build & Deployment Scripts

Custom shell scripts were used to simplify Docker image building and application deployment on the EC2 instance.

buildDockerScript.sh
<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 12 59 45 PM" src="https://github.com/user-attachments/assets/01ab7c9a-b88e-4c5c-8d80-2fac6c2fc9bc" />


deploy.sh
<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 1 00 01 PM" src="https://github.com/user-attachments/assets/9bfbe4d7-304f-42ec-8e54-b53d1d9c4e55" />



7. Django Configuration

To allow external access to the application, the EC2 public IP address was added to Django’s ALLOWED_HOSTS configuration.

Screenshot: settings.py (ALLOWED_HOSTS)

<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 1 02 47 PM" src="https://github.com/user-attachments/assets/4d2eeb46-de37-4d9d-9a52-47524b91db42" />

8. Database Persistence with SQLite

SQLite was implemented to ensure data persistence in the containerized environment.

Instead of storing the database inside the Docker container (which would be lost on redeployment), the SQLite database file was mounted from the EC2 host into the container. This ensures that application data remains available even when containers are stopped, removed, or recreated.

As a result:

Users can sign up and log in successfully

User accounts persist across deployments

Users can create posts

Created posts remain available after container restarts

<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 1 05 26 PM" src="https://github.com/user-attachments/assets/0966d731-fdf9-40fb-844b-bab9277ef215" />

9. Jenkins Build Verification

The Jenkins pipeline completed successfully with all stages passing, confirming that the CI/CD workflow executed as expected.

Screenshot: Jenkins successful build (green pipeline)
<img width="1680" height="1050" alt="Screenshot 2025-12-15 at 1 09 27 PM" src="https://github.com/user-attachments/assets/0cd8235f-4e6e-4355-a97f-b9a7451ce6f7" />



11. Errors Encountered & Resolutions

During deployment, the following issues were encountered and resolved:

Jenkins script parsing errors were fixed by separating deployment logic into scripts.

Old application versions were resolved by ensuring clean redeployments.

Port mismatches between Docker and Django were corrected.

Django ALLOWED_HOSTS restriction was resolved by adding the EC2 public IP.

SQLite persistence was implemented to prevent data loss.

These fixes resulted in a stable and reliable deployment pipeline.

12. Conclusion

The StudyBud application was successfully deployed using a Docker-based CI/CD pipeline with Jenkins, hosted on AWS EC2, and configured with persistent SQLite storage.
