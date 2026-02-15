🚀 MERN Stack Deployment on AWS using Terraform & Ansible
=========================================================

📌 Project Objective
--------------------

This project demonstrates end-to-end deployment of a MERN (MongoDB, Express, React, Node.js) application on AWS using:

- **Terraform** → Infrastructure as Code
- **Ansible** → Configuration Management
- **AWS EC2 + VPC Networking**

The goal is to provision secure infrastructure and deploy the application in a production-style architecture.

---

🏗 Architecture Overview
========================

🔹 Infrastructure Design
------------------------

- Custom VPC (10.0.0.0/16)
- Public Subnet (Web Server)
- Private Subnet (Database Server)
- Internet Gateway
- NAT Gateway
- Bastion-based SSH Access
- Security Group isolation

🔹 Deployment Architecture
--------------------------

`Internet    ↓ Internet Gateway    ↓ Public Subnet    ↓ Web EC2 (React + Express + PM2)    ↓ Private Subnet    ↓ MongoDB EC2`

---

📂 Repository Structure
=======================

`TravelMemory-AWS/ │ ├── terraform/ │   ├── provider.tf │   ├── variables.tf │   ├── main.tf │   ├── outputs.tf │ ├── ansible/ │   ├── inventory.ini │   ├── web.yml │   ├── db.yml │ ├── backend/ ├── frontend/ └── README.md`

---

⚙️ Part 1 -- Infrastructure Provisioning (Terraform)
======================================================

1️⃣ Provider Configuration
----------------------------

Defined AWS provider and region.

2️⃣ Networking Components
---------------------------

- VPC
- Public & Private Subnets
- Route Tables
- Internet Gateway
- NAT Gateway

3️⃣ Security Groups
---------------------

- Web SG:

  - SSH (restricted to my IP)
  - Port 3000 (Application)
- DB SG:

  - Port 27017 (only from Web SG)
  - SSH (only from Web SG)

4️⃣ EC2 Instances
-------------------

- Public EC2 → Web Server
- Private EC2 → MongoDB Server

5️⃣ Terraform Deployment
--------------------------

`terraform init terraform plan terraform apply`

Output:

`web_public_ip = <public-ip> db_private_ip = <private-ip>`

---

⚙️ Part 2 -- Configuration & Deployment (Ansible)
===================================================

1️⃣ Inventory Configuration
-----------------------------

Configured Ansible with SSH jump host for private EC2 access.

2️⃣ Database Server Setup
---------------------------

- Installed MongoDB 6.0
- Enabled systemd service
- Configured bindIp
- Verified service status

3️⃣ Web Server Setup
----------------------

- Installed Node.js 18
- Installed PM2
- Cloned MERN repository
- Installed backend & frontend dependencies
- Built React frontend
- Started backend using PM2

4️⃣ Application Configuration
-------------------------------

- Created `.env` file
- Configured MongoDB connection
- Modified Express server to listen on `0.0.0.0`

---

🧪 Application Verification
===========================

Backend Test
------------

`curl http://localhost:3000/hello`

Output:

`Hello World!`

Frontend Test
-------------

Access in browser:

`http://<web_public_ip>:3000`

Verified:

- React UI loads successfully
- New trip entries can be created
- Data persists in MongoDB after refresh

---

🔐 Security Implementation
==========================

- MongoDB is deployed in private subnet
- No public database exposure
- SSH restricted by IP
- Bastion-based internal access
- Separate security groups for web and DB
- Infrastructure managed via IaC

---

📸 Screenshots Included
=======================

The submission includes screenshots showing:

1. Terraform apply success      `<img width="1345" height="447" alt="Screenshot from 2026-02-16 03-49-52" src="https://github.com/user-attachments/assets/70a9d848-581e-4d2c-aa59-cf7506172fc0" />`
2. AWS VPC & subnet configuration        `<img width="1345" height="447" alt="Screenshot from 2026-02-16 03-51-24" src="https://github.com/user-attachments/assets/cd9d91b5-03e9-49a3-8244-74de648106e8" />`        `<img width="1345" height="447" alt="Screenshot from 2026-02-16 03-51-35" src="https://github.com/user-attachments/assets/42017551-4002-4cb2-9d23-56030940d55a" />`        `<img width="1345" height="447" alt="Screenshot from 2026-02-16 03-51-58" src="https://github.com/user-attachments/assets/a0c4a0bd-b36d-4347-8fd3-eaaeb0fef22d" />`
3. EC2 instances running    `<img width="1345" height="447" alt="Screenshot from 2026-02-16 03-52-44" src="https://github.com/user-attachments/assets/6ccf2362-6c95-4e71-954f-1989992e2b43" />`
4. Security group rules        `<img width="1345" height="622" alt="Screenshot from 2026-02-16 03-53-38" src="https://github.com/user-attachments/assets/cac9ce78-dd07-42ec-a830-26241f48ef72" />`
5. Ansible playbook execution logs        `<img width="1345" height="516" alt="Screenshot from 2026-02-16 03-56-04" src="https://github.com/user-attachments/assets/a5ea1e39-2508-4c3f-b042-d5b3267b75da" />`        `<img width="1345" height="551" alt="Screenshot from 2026-02-16 03-57-05" src="https://github.com/user-attachments/assets/1bd7c8f4-7309-4924-9a57-16c6a989d637" />`
6. MongoDB service running        `<img width="1345" height="551" alt="Screenshot from 2026-02-16 03-58-19" src="https://github.com/user-attachments/assets/39cf6dfc-236c-4762-9fbc-87cbb45a97e6" />`        `<img width="1345" height="551" alt="Screenshot from 2026-02-16 03-58-33" src="https://github.com/user-attachments/assets/e635ca1b-fbec-448c-a5d9-296158e4cbf3" />`
7. Application UI displaying stored data        `<img width="1345" height="551" alt="Screenshot from 2026-02-16 03-59-12" src="https://github.com/user-attachments/assets/403a42c7-aac2-4fe7-92a3-9dfa7df4924d" />`                `<img width="1345" height="551" alt="Screenshot from 2026-02-16 03-59-22" src="https://github.com/user-attachments/assets/b6e6b22b-a196-48a7-ac8e-6ebb111cccc9" />`
8. PM2 process status
   `<img width="783" height="96" alt="Screenshot from 2026-02-16 04-12-16" src="https://github.com/user-attachments/assets/1ede4e84-6b6e-41d4-81ac-ef5dff2ace6f" />`

All screenshots reflect the actual running application state with persisted data.

---

🔄 Application Flow
===================

`Browser    ↓ React Frontend    ↓ Express Backend API    ↓ MongoDB (Private EC2)`

---

🏁 Conclusion
=============

This project successfully demonstrates:

- Infrastructure provisioning using Terraform
- Secure network segmentation in AWS
- Automated configuration using Ansible
- Deployment of a full MERN stack application
- Production-style architecture with private database isolation

The system is fully functional and verified with persistent data storage.


---

🧑‍💻 Author
-------------

**DEEPIKA NARENDRAN**
*DevOps Technical Lead | MCAD Program*
📧 deepika2.ytb@gmail.com
💼 [GitHub: JoinDeeHub](https://github.com/JoinDeeHub)
📍 Bengaluru, India
