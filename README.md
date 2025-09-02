# terraform-mini-project

---

This project demonstrates the **provisioning of AWS infrastructure with Terraform** and **configuration management with Ansible**.
It creates **three Ubuntu EC2 instances** in a **private subnet**, deploys them behind an **Elastic Load Balancer (ELB)**, and uses **Ubuntu on WSL as a bastion host** for secure access.
Each instance is configured with **Apache** to serve a unique HTML page for identification.

---

## **Table of Contents**

* [Architecture Overview](#architecture-overview)
* [Tools and Technologies](#tools-and-technologies)
* [Project Structure](#project-structure)
* [Prerequisites](#prerequisites)
* [Setup Instructions](#setup-instructions)

  * [1. Clone the Repository](#1-clone-the-repository)
  * [2. Configure AWS Credentials](#2-configure-aws-credentials)
  * [3. Deploy Infrastructure with Terraform](#3-deploy-infrastructure-with-terraform)
  * [4. Access Private Instances via Bastion Host](#4-access-private-instances-via-bastion-host)
  * [5. Configure Instances with Ansible](#5-configure-instances-with-ansible)
* [Verification](#verification)
* [Clean Up](#clean-up)
* [Future Enhancements](#future-enhancements)

---

## **Architecture Overview**

The setup includes:

* **VPC and Networking**

  * Public subnet for the Bastion host and Load Balancer
  * Private subnet for EC2 instances
* **Three Ubuntu EC2 Instances**

  * Accessible only via Bastion host or Load Balancer
* **Elastic Load Balancer (ELB)**

  * Distributes incoming HTTP traffic evenly
* **Apache Configuration**

  * Managed by Ansible
  * Unique HTML pages per instance
* **Bastion Host**

  * Securely connects to instances in the private subnet using the PEM key

---

## **Tools and Technologies**

* **AWS** – EC2, VPC, ALB, Security Groups
* **Terraform** – Infrastructure as Code
* **Ansible** – Configuration management
* **Ubuntu on WSL (Windows Subsystem for Linux)** – Bastion host environment
* **Apache HTTP Server** – Web server

---

## **Project Structure**

```
terraform-mini-project-ansible/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf

├── ansible/
│   ├── host-inventory
│   ├── playbook.yml
└── README.md
```

---

## **Prerequisites**

* **AWS Account** with permissions for EC2, VPC, and ELB
* **Installed Tools**:

  * [Terraform](https://developer.hashicorp.com/terraform/downloads) (v5.0+)
  * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.14+)
  * [AWS CLI](https://aws.amazon.com/cli/) (v2+)
  * [Ubuntu WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
* **IAM Credentials**
* **SSH Key Pair**

  * `.pem` file for secure instance access

---

## **Setup Instructions**

### **1. Clone the Repository**

```bash
git clone https://github.com/Adepetu-Oluwasegun/terraform-mini-project.git
cd 
```

---

### **2. Configure AWS Credentials**

```bash
aws configure
```

Or export them:

```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=your_region
```

---

### **3. Deploy Infrastructure with Terraform**

Navigate to the Terraform directory:

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

**Outputs include:**

* ALB DNS name
* Private IPs of EC2 instances
* Bastion host public IP
* 

---

### **4. Access Private Instances via Bastion Host**

1. Copy the `.pem` file into your **WSL environment**:

   ```bash
   cp /mnt/c/Users/<YourName>/Downloads/my-key.pem ~/.ssh/
   chmod 400 ~/.ssh/my-key.pem
   ```

2. SSH into the **Bastion host**:

   ```bash
   ssh -i ~/.ssh/my-key.pem ubuntu@<bastion_public_ip>
   ```

3. From the Bastion host, SSH into the **private EC2 instances**:

   ```bash
   ssh -i ~/.ssh/my-key.pem ubuntu@<private_instance_ip>
   ```

---

### **5. Configure Instances with Ansible**

Update the **inventory file** in `ansible/inventory.ini` with private IPs of the EC2 instances.

Run the Ansible playbook:

```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```

This installs Apache and deploys unique HTML pages to identify each instance.

---

## **Verification**

1. Get the ELB DNS from Terraform output:

   ```bash
   terraform output elb_dns_name
   ```

2. Open the DNS in your browser and refresh the page multiple times to confirm traffic rotation among the three instances.

---

## **Clean Up**

Destroy all resources to avoid incurring charges:

```bash
cd terraform
terraform destroy -auto-approve
```

---

## **Future Enhancements**

* Implement **Auto Scaling Groups** for EC2
* Add **HTTPS** with ACM certificates
* Use **dynamic inventory** in Ansible
* Automate CI/CD pipelines for deployments

---


