# AWS Application Load Balancer with Nginx using Terraform

## Project Overview

This project demonstrates how to provision a scalable and highly available web infrastructure on **AWS** using **Infrastructure as Code (IaC)** with **Terraform**.

The infrastructure includes a custom **VPC**, public and private subnets across multiple availability zones, an **Application Load Balancer**, and **EC2 instances running Nginx** that display instance-specific information.

The goal of this project is to simulate a production-like architecture where traffic from the internet is routed through a load balancer to backend servers running in private subnets.

---

## Technologies Used

* AWS
* Terraform
* Nginx
* Linux (Ubuntu)
* Git & GitHub

---

## Architecture

The architecture follows a **multi-tier design** with public and private networking layers.

Components included:

1. **VPC**

   * Custom Virtual Private Cloud created using Terraform.

2. **Public Subnets**

   * Two public subnets in different Availability Zones.
   * Host the Application Load Balancer.

3. **Private Subnets**

   * Two private subnets in different Availability Zones.
   * Host backend EC2 instances running Nginx.

4. **Internet Gateway**

   * Allows internet access for resources in public subnets.

5. **NAT Gateway**

   * Enables private instances to access the internet for package installation.

6. **Application Load Balancer**

   * Internet-facing load balancer.
   * Routes incoming traffic to backend EC2 instances.

7. **EC2 Instances**

   * Two Ubuntu instances running Nginx.
   * Serve a custom HTML page displaying:

     * Instance ID
     * Availability Zone
     * Server information

---

## Architecture Diagram

![Architecture](architecture.png)

---

## Project Structure

```
terraform-aws-alb-nginx
│
├── main.tf
├── variables.tf
├── terraform.tfvars
├── provider.tf
│
├── vpc.tf
├── security-groups.tf
├── ec2.tf
├── alb.tf
│
├── user-data.sh
│
├── outputs.tf
│
└── README.md
```

---

## Infrastructure Details

### VPC Configuration

* Custom VPC
* CIDR block configured via variables
* DNS hostnames enabled

### Subnets

| Subnet   | Type    | Availability Zone |
| -------- | ------- | ----------------- |
| public1  | Public  | ap-south-1a       |
| public2  | Public  | ap-south-1b       |
| private1 | Private | ap-south-1a       |
| private2 | Private | ap-south-1b       |

---

### Security Groups

#### ALB Security Group

Allows:

* HTTP (Port 80) from anywhere

#### EC2 Security Group

Allows:

* HTTP (Port 80) from ALB Security Group
* SSH (Port 22) for debugging

---

### EC2 Instances

Two EC2 instances are created using Terraform **for_each** with **locals**.

Each instance:

* Runs Ubuntu
* Installs Nginx via user-data
* Serves a custom web page displaying instance metadata.

Example output:

```
Hello World

Instance ID: i-xxxxxxxx

Availability Zone: ap-south-1a

Served by: Nginx
```

---

## Load Balancing

The **Application Load Balancer (ALB)** distributes incoming HTTP traffic across both EC2 instances.

Features:

* Internet facing
* Health checks enabled
* Target group attached to EC2 instances
* Listener configured on port 80

Refreshing the ALB DNS will show responses from different backend instances.

---

## Deployment Steps

### 1 Clone Repository

```
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 2 Initialize Terraform

```
terraform init
```

### 3 Validate Configuration

```
terraform validate
```

### 4 Plan Infrastructure

```
terraform plan
```

### 5 Deploy Infrastructure

```
terraform apply
```

Type `yes` when prompted.

---

## Access the Application

After successful deployment, Terraform will output the **ALB DNS name**.

Example:

```
http://devops-alb-123456.ap-south-1.elb.amazonaws.com
```

Open the URL in your browser to see the Nginx page.

Refreshing the page will display responses from different instances.

---

## Terraform Concepts Used

This project demonstrates several important Terraform concepts:

* Variables
* Locals
* for_each
* Dynamic blocks
* Modular resource structure
* User data scripts
* AWS networking components

---

## Cleanup

To destroy all resources:

```
terraform destroy
```

---

## Author

Pranay Waghmare
DevOps Engineer
Pune, India

---

## Purpose of this Project

This project was created to demonstrate practical knowledge of:

* AWS infrastructure design
* Terraform Infrastructure as Code
* Load balancing architecture
* Secure networking using public and private subnets
* Automated server configuration using user-data scripts
