# 🚀 Secure AWS Infrastructure Deployment with Terraform

## 📖 Project Overview

This project demonstrates the deployment of a secure AWS environment using **Terraform** and **Infrastructure as Code (IaC)** principles. The goal was to automate the provisioning of AWS networking, compute, storage, load balancing, and security services while gaining hands-on experience with cloud infrastructure management and Terraform workflows.

By deploying resources through code instead of manually configuring them in the AWS console, this project helped reinforce automation, consistency, and cloud security best practices.

---

## 🏗️ Architecture

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/a40b55cf-f337-4577-aeed-53a7b52a2ce9" />


---

## 🛠️ Technologies Used

### ☁️ AWS Services

* Amazon VPC
* Amazon EC2
* Amazon EBS
* Application Load Balancer (ALB)
* AWS WAF
* Internet Gateway
* Route Tables
* Security Groups

### ⚙️ Infrastructure as Code

* Terraform

---

## ✨ Key Features

✅ Provisioned a custom AWS VPC with public subnets across multiple Availability Zones

✅ Configured route tables and an Internet Gateway to enable internet connectivity

✅ Deployed an EC2 web server with encrypted EBS storage

✅ Implemented security groups following least-privilege access principles

✅ Configured an Application Load Balancer with target groups and health checks

✅ Protected web traffic using AWS WAF managed security rules

✅ Managed infrastructure deployment through Terraform plan, apply, and destroy workflows

---

## 📸 Deployment Screenshots

### 🚀 Terraform Deployment

<img width="1312" height="912" alt="Screenshot 2026-05-29 at 15 09 30" src="https://github.com/user-attachments/assets/6dd4a47c-342c-4755-877c-bf04f97c3a0e" />

---

### ⚖️ Application Load Balancer

<img width="1838" height="1145" alt="image" src="https://github.com/user-attachments/assets/c8dff871-728a-4c1f-ae48-1a6c1a3e9f66" />


---

### ❤️ Healthy Target Group

**Insert Screenshot: Healthy Target Status**

<img width="1838" height="1145" alt="image" src="https://github.com/user-attachments/assets/e3457947-62d9-4913-9159-9b8091864e09" />


### 🔒 AWS WAF Protection

**Insert Screenshot: WAF Associated with ALB**

<img width="1838" height="1145" alt="image" src="https://github.com/user-attachments/assets/3d516af1-1a67-4cd1-9fad-118d38ff1abf" />


## 🎯 Skills Demonstrated

* Infrastructure as Code (IaC)
* AWS Networking
* EC2 Administration
* EBS Storage Management
* Load Balancing
* Web Application Security
* Security Group Configuration
* Terraform State Management
* Cloud Troubleshooting
* AWS Architecture Design

---

## 🧠 Key Takeaways

Through this project, I strengthened my understanding of AWS networking, security, and Infrastructure as Code. I gained hands-on experience deploying cloud infrastructure with Terraform, managing resource dependencies, troubleshooting deployment issues, and implementing AWS security best practices.

One of the biggest lessons learned was that Terraform is less about memorizing code and more about understanding how cloud resources work together and how to deploy infrastructure consistently through automation.

---

## 🚀 Future Improvements

### 🔐 Security

* Move EC2 instances into private subnets
* Configure HTTPS using AWS Certificate Manager (ACM)
* Add AWS GuardDuty and Security Hub

### 📊 Monitoring

* Implement AWS CloudTrail
* Configure CloudWatch dashboards and alerts
* Create SNS notifications for infrastructure events

### ⚙️ Automation

* Store Terraform state remotely using Amazon S3
* Implement DynamoDB state locking
* Deploy infrastructure through GitHub Actions CI/CD pipelines

### 📈 Scalability

* Deploy Auto Scaling Groups
* Expand workloads across multiple Availability Zones
* Improve fault tolerance and availability
