# November Mini Project - CI/CD Pipeline Deployment

## Project Overview
This project demonstrates a complete CI/CD pipeline for a Python application using:

- Docker
- Jenkins
- Docker Hub
- AWS EC2



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
- **IP:** 3.235.182.92  
- **Port:** 8000  
- **App URL:** [http://3.235.182.92:8000/](http://3.235.182.92:8000/)

---

## Screenshots (Deliverables)

### Jenkinsfile

<img src="https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-B/static/images/Screenshot%202025-12-12%20at%201.15.07%E2%80%AFAM.png?raw=true">

<img src="https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-B/static/images/Screenshot%202025-12-12%20at%201.15.28%E2%80%AFAM.png?raw=true">

### Jenkins Job Console Output

**Jenkins Console 1**  
<img src='https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-B/static/images/Screenshot%202025-12-12%20at%201.09.36%E2%80%AFAM.png?raw=true'>

**Jenkins Console 2**  
<img src="https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-B/static/images/Screenshot%202025-12-12%20at%201.09.52%E2%80%AFAM.png?raw=true">

### Application Running Live

**App Running**  
<img src="https://github.com/women-techsters-fellowship/november_mini_project/blob/GROUP-B/static/images/Screenshot%202025-12-15%20at%209.01.28%E2%80%AFPM.png?raw=true">

---

## Contributors
See `participants.txt` for full list of contributors.

**Names of Group-J contributors:**  
- Audrey Asheley Amarh
- Miracle Olorunsola
- Favour Lawrence
- Mmesoma Patrick 


---

## Notes
- Application is fully containerized and deployable via Jenkins pipeline.  
- Docker Desktop must be running locally for Jenkins to build images successfully.  
- CI/CD setup allows deployment to EC2 without manual cloning.
