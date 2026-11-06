Automated MERN Application Deployment on AWS

Production-ready deployment of the TravelMemory MERN stack using Terraform for Infrastructure as Code (IaC) and Ansible for automated configuration management.

Architecture Overview

                          Internet Gateway
                                 │
                     ┌───────────▼───────────┐
                     │   Public Subnet       │
                     │   10.0.1.0/24         │
                     │                       │
                     │   [ EC2 Web Server ]  │
                     │   - Nginx (Port 80)   │
                     │   - React Frontend    │
                     │   - Express API (5000)│
                     │   - NAT Gateway       │
                     └───────────┬───────────┘
                                 │ (SSH JumpHost / ProxyCommand)
                     ┌───────────▼───────────┐
                     │   Private Subnet      │
                     │   10.0.2.0/24         │
                     │                       │
                     │   [ EC2 DB Server ]   │
                     │   - MongoDB 7.0       │
                     │     (Port 27017)      │
                     └───────────────────────┘


Region: ap-southeast-2 (Sydney)

VPC: Custom VPC (10.0.0.0/16)

Web Tier (Public Subnet): Hosts the Nginx reverse proxy, Node.js backend managed via PM2, and built React static assets. Also hosts the NAT Gateway for private subnet outbound internet access.

Database Tier (Private Subnet): Completely isolated MongoDB instance with no direct internet ingress; receives outbound internet access via NAT Gateway and administrative access through an SSH JumpHost bastion.

Tech Stack & Tools

Cloud Provider: Amazon Web Services (AWS)

Infrastructure as Code (IaC): Terraform

Configuration Management: Ansible

Web Server & Reverse Proxy: Nginx

Process Manager: PM2

Backend Runtime & Framework: Node.js 18.x, Express

Frontend Framework: React

Database Engine: MongoDB 7.0 Community Edition

Project Structure

.
├── ansible/
│   ├── ansible.cfg              # Ansible configuration & SSH JumpHost settings
│   ├── inventory.ini            # Dynamic inventory with ProxyCommand
│   ├── playbook.yml             # Full provisioning & deployment playbook
│   └── travelmemory.env.j2      # Backend environment template
├── terraform/
│   ├── main.tf                  # VPC, subnets, gateways, routes, security groups, EC2
│   ├── variables.tf             # Configurable input variables (region, CIDRs, AMI)
│   └── outputs.tf               # Outputs for Web public IP and DB private IP
├── .gitignore                   # Excludes SSH keys, states, and temporary caches
└── README.md                    # Project documentation


Prerequisites

AWS CLI configured with valid IAM administrator credentials.

Terraform (>= 1.5.0) installed on the local system.

Ansible (>= 2.15.0) installed locally.

SSH Key Pair (mern-deployer-key.pem) saved locally in ~/.ssh/.

Deployment Instructions

1. Provision Infrastructure with Terraform

cd terraform
terraform init
terraform plan
terraform apply -auto-approve


Terraform outputs the public IP for the Web Server and the private IP for the MongoDB Database Server.

2. Configure & Deploy with Ansible

Update ansible/inventory.ini with the provisioned IP addresses, then run:

cd ../ansible
ansible-playbook -i inventory.ini playbook.yml


The playbook executes the following tasks:

Installs and configures MongoDB 7.0 on the private database instance.

Sets up UFW rules on the database server to permit traffic only from the web security group.

Installs Node.js 18.x, Git, PM2, and Nginx on the public web server.

Clones the TravelMemory repository.

Configures backend environment parameters and daemonizes Express using PM2.

Builds the production React frontend bundle.

Deploys Nginx configuration to reverse-proxy /api to Express (http://localhost:5000) and serve static React assets on port 80.

Verification

## Verification

- **Live Application URL:** [http://3.107.57.14](http://3.107.57.14)
- **Backend API Endpoint:** http://3.107.57.14:5000/trip
- **Database Connection:** Verified on private IP 10.0.2.28:27017
