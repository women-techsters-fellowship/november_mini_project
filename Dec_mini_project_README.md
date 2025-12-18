# December Mini Project - CI/CD with GitHub Actions
 
## Overview

This project implements a complete CI/CD pipeline for a Python application using Docker and GitHub Actions.  

The Docker image is built and pushed to Docker Hub, then pulled and run on an AWS EC2 instance.
 
> GitHub Actions was used instead of Jenkins as allowed.  
> No code was cloned or built on the EC2 instance.
 
---
 
##  Docker Image Information

- **Image Name:** `lydiahlaw/dec-mini-project`

- **Registry:** Docker Hub

- **Port Exposed:** `8082`
 
---
 
## GitHub Actions Secrets Configuration
 
| Secret Name | Description |

|------------|------------|

| DOCKER_USERNAME | Docker Hub username |

| DOCKER_PASSWORD | Docker Hub password |

| EC2_HOST | EC2 public IP address |

| EC2_SSH_KEY | EC2 private SSH key |
 
---
 
##  Project Deliverables
 
### Screenshots

![GitHub Actions Workflow](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/deploy%20yaml%20workflow1.png)
![GitHub Actions Workflow]( https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/deploy%20yaml2.png)

GitHub Actions Pipeline Console Output
![GitHub Actions Console Output](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/github%20deployment%20completed.png)
![GitHub Actions Console Output](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/github%20deployment%201.png)
![GitHub Actions Console Output](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/github%20deployment%202.png)
![GitHub Actions Console Output](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/githubdeployment%203.png)

 Application Running Live
![Application Running](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/dec-mini-project-screenshots/ec2instance%20live%20app.png)

EC2 Deployment Details
EC2 Public IP: 23.20.140.127
Application Port: 8082
http://23.20.140.127:8082

### Contributors
All GROUP-J contributors are listed in the participants.txt file.

1. Chidera Pamela Alaeto
2. Jemimah Byencit Rimdan
3. Nwaonyeoma kosisochukwu Jennifer
4. Victoria Amarachi Philip
5. Linda Joseph Effiong
6. Favour Chinaza Michael
7. Umeh Chinenye Eucharia
8. Akande Iteoluwakiisi
9. Patience chopetta kabeyu
10. Lydiah Nganga


 
