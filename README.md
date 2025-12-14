# November Mini Project  - CI/CD Pipeline Deployment

## Project Overview
This project demonstrates a complete CI/CD pipeline for a Python application using:

- Docker
- Jenkins
- Docker Hub
- AWS EC2

The application is containerized, built via CI, pushed to Docker Hub, and deployed to an EC2 instance via CD without cloning the repository on the server.

---

## Technologies Used
- Python
- Docker
- Jenkins
- Docker Hub
- AWS EC2
- Git & GitHub

---

## CI/CD Pipeline Flow

1. Code is pushed to GitHub
2. Jenkins pulls the repository
3. Docker image is built
4. Image is pushed to Docker Hub
5. Jenkins connects to EC2 via SSH
6. EC2 pulls the Docker image
7. Container is started on EC2

---

## Application Access

- **51.21.251.27:** 
- **Port:** `8000`
- **App URL:** `http://51.21.251.27:8000`

---

## Screenshots (Deliverables)

### Jenkinsfile
![Jenkins pipeline1](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/085f4e11-6d0d-4f20-b5e3-2624280e831e.jpg)

![Jenkins pipeline2](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/7a93bbc1-3015-473f-8151-fa39447a7ae6.jpg)

![Jenkins pipeline3](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/376379ce-61dc-464e-a290-9e44804ee1b5.jpg)

![Jenkins pipeline4](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/1ab0c598-5995-4e39-a775-836b63e9d215.JPG)


### Jenkins Job Console Output
![Jenkins Console1](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/e5ae8955-4260-4f21-a8af-b710b6ce7e97.JPG)

![Jenkins Console2](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/0a97fcc9-8d1d-449f-9c3f-1c2c10dbbc43.JPG)

### Application Running Live
![App Running](https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-J/screenshots/9e0c9d74-d16e-4ca7-abf0-48f544f4508e.JPG)

---

## Contributors
See `participants.txt` for full list of contributors.
# Names of Group-J contributors
1. Chidera Pamela Alaeto
2. Jemimah Byencit Rimdan
3. Nwaonyeoma kosisochukwu Jennifer
4. Victoria Amarachi Philip
5. Linda Joseph Effiong
6. Favour Chinaza Michael
7. Umeh Chinenye Eucharia
8. Akande Iteoluwakiisi
9. Patience chopetta kabeyu
10. lydia Nganga

---

## Notes
- The repository was **not cloned on EC2**
- Deployment was done by pulling the Docker image from Docker Hub
- Free-tier AWS resources were used
