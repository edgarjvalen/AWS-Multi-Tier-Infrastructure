# AWS Multi-Tier Infrastructure with Terraform

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

A production-ready, multi-tier web application infrastructure deployed on AWS using Terraform. This project demonstrates Infrastructure as Code (IaC) best practices with proper network segmentation, load balancing, and security configurations.

---

## Architecture Overview

This project deploys a **2-tier web application** with the following components:

- **Network Layer**: Custom VPC with public and private subnets across multiple availability zones
- **Compute Layer**: Auto-scaled web servers and application servers
- **Load Balancing**: Application Load Balancer for traffic distribution
- **Security**: Multi-layered security groups with least-privilege access
- **High Availability**: Resources distributed across `us-east-1a` and `us-east-1b`

---

## Architecture Diagram

```
                              Internet
                                 ↓
                    ┌─────────────────────────┐
                    │    Application Load     │
                    │    Balancer (Port 80)   │
                    └─────────────────────────┘
                                 ↓
    ┌────────────────────────────────────────────────────────┐
    │                    VPC: 10.0.0.0/16                    │
    │                                                        │
    │  ┌──────────────────────┐  ┌──────────────────────┐    │
    │  │   AZ: us-east-1a     │  │   AZ: us-east-1b     │    │
    │  │                      │  │                      │    │
    │  │  Public Subnet       │  │  Public Subnet       │    │
    │  │  10.0.1.0/24         │  │  10.0.2.0/24         │    │
    │  │  ┌────────────────┐  │  │  ┌────────────────┐  │    │
    │  │  │ Web Server 1   │  │  │  │ Web Server 2   │  │    │
    │  │  │ EC2 (t2.micro) │  │  │  │ EC2 (t2.micro) │  │    │
    │  │  │ Nginx          │  │  │  │ Nginx          │  │    │
    │  │  └────────────────┘  │  │  └────────────────┘  │    │
    │  │  ┌────────────────┐  │  │                      │    │
    │  │  │  NAT Gateway   │  │  │                      │    │
    │  │  └────────────────┘  │  │                      │    │
    │  └──────────────────────┘  └──────────────────────┘    │
    │                                                        │
    │  ┌──────────────────────┐                              │
    │  │   AZ: us-east-1a     │                              │
    │  │                      │                              │
    │  │  Private Subnet      │                              │
    │  │  10.0.10.0/24        │                              │
    │  │  ┌────────────────┐  │                              │
    │  │  │  App Server    │  │                              │
    │  │  │ EC2 (t2.micro) │  │                              │
    │  │  │ Port 8080      │  │                              │
    │  │  └────────────────┘  │                              │
    │  └──────────────────────┘                              │
    │                                                        │
    │  Internet Gateway ←→ NAT Gateway ←→ Private Subnet     │
    └────────────────────────────────────────────────────────┘
```

---

## Features

- **High Availability**: Multi-AZ deployment with Application Load Balancer
- **Network Segmentation**: Public and private subnets with proper routing
- **Security**: Layered security groups following the principle of least privilege
- **Scalability**: Infrastructure ready for auto-scaling configuration
- **NAT Gateway**: Secure outbound internet access for private subnet resources
- **Infrastructure as Code**: Fully automated deployment using Terraform

---

## Project Structure

```
terraform-aws-multi-tier/
│
├── main.tf                 # Main infrastructure resources
├── variables.tf            # Input variables (optional)
├── outputs.tf              # Output values (optional)
├── provider.tf             # AWS provider configuration
├── terraform.tfvars        # Variable values (optional)
└── README.md               # This file
```

---

## Technologies Used

| Technology | Purpose |
|------------|---------|
| **Terraform** | Infrastructure as Code |
| **AWS VPC** | Virtual Private Cloud |
| **AWS EC2** | Compute instances (t2.micro) |
| **AWS ALB** | Application Load Balancer |
| **AWS NAT Gateway** | Network Address Translation |
| **Nginx** | Web server software |
| **Amazon Linux 2** | Operating system |

---

## Prerequisites

Before you begin, ensure you have the following installed:

- AWS Account with appropriate IAM permissions
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- [Terraform](https://www.terraform.io/downloads.html) (v1.0 or higher)
- Basic understanding of AWS networking concepts

---

## Infrastructure Components

### Network Configuration

| Component | CIDR Block | Availability Zone | Type |
|-----------|------------|-------------------|------|
| **VPC** | `10.0.0.0/16` | us-east-1 | N/A |
| **Public Subnet 1** | `10.0.1.0/24` | us-east-1a | Public |
| **Public Subnet 2** | `10.0.2.0/24` | us-east-1b | Public |
| **Private Subnet** | `10.0.10.0/24` | us-east-1a | Private |

### Security Groups

#### ALB Security Group
```
Inbound:
  - Port 80 (HTTP) from 0.0.0.0/0
Outbound:
  - All traffic
```

#### Web Server Security Group
```
Inbound:
  - Port 80 (HTTP) from ALB Security Group
  - Port 22 (SSH) from your IP address
Outbound:
  - All traffic
```

#### App Server Security Group
```
Inbound:
  - Port 8080 from Web Server Security Group
  - Port 22 (SSH) from Web Server Security Group
Outbound:
  - All traffic
```

---

## Deployment Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/terraform-aws-multi-tier.git
cd terraform-aws-multi-tier
```

### Step 2: Configure AWS Credentials

```bash
aws configure
```

Enter your AWS Access Key ID, Secret Access Key, and default region (`us-east-1`).

### Step 3: Initialize Terraform

```bash
terraform init
```

This downloads the required AWS provider plugins.

### Step 4: Review the Execution Plan

```bash
terraform plan
```

Review the resources that will be created.

### Step 5: Deploy the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### Step 6: Access Your Application

Once deployment completes, Terraform will output the ALB DNS name:

```bash
Outputs:

alb_dns_name = "main-alb-1234567890.us-east-1.elb.amazonaws.com"
```

Navigate to `http://<alb-dns-name>` in your browser to see your application.

---

## Testing the Infrastructure

### Test Load Balancer Distribution

```bash
# Refresh multiple times to see traffic distributed between servers
curl http://<alb-dns-name>
```

You should see responses alternating between "Web Server 1" and "Web Server 2".

### SSH to Web Server (Jump Box)

```bash
ssh -i your-key.pem ec2-user@<web-server-public-ip>
```

### SSH to App Server (from Web Server)

```bash
# First SSH to web server, then:
ssh ec2-user@<app-server-private-ip>
```

---

## Cleanup

> **Important**: To avoid ongoing AWS charges, destroy all resources when done:

```bash
terraform destroy
```

Type `yes` when prompted. This will delete all resources created by Terraform.

---

## Key Learning Outcomes

Through this project, I gained hands-on experience with:

- Designing multi-tier architecture on AWS
- Implementing proper network segmentation (public vs private subnets)
- Configuring Application Load Balancers and Target Groups
- Managing Security Groups with least-privilege access
- Working with NAT Gateways for secure internet access
- Understanding Terraform resource dependencies
- Implementing Infrastructure as Code (IaC) best practices
- Configuring route tables for public and private traffic flow

---

## Security Best Practices

This project implements several security best practices:

- **Network Isolation**: App server in private subnet with no direct internet access
- **Least Privilege**: Security groups restrict traffic between tiers
- **SSH Restrictions**: SSH access limited to specific IP addresses
- **Jump Box Pattern**: App server only accessible through web servers
- **Controlled Egress**: Private subnet internet access only through NAT Gateway

---

## Future Enhancements

- Add Auto Scaling Groups for web and app tiers
- Implement RDS database in private subnet
- Configure CloudWatch monitoring and alarms
- Add HTTPS/SSL with AWS Certificate Manager
- Implement S3 backend for Terraform state
- Add Route53 for custom domain name
- Configure CloudFront CDN
- Implement backup and disaster recovery
- Add CI/CD pipeline (GitHub Actions / Jenkins)
- Use Terraform modules for reusability

---

## Helpful Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS ALB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

## Troubleshooting

### Issue: Terraform apply fails with authentication error
**Solution**: Run `aws configure` and ensure your credentials are correct.

### Issue: Can't access ALB DNS
**Solution**: Wait 2-3 minutes after `terraform apply` for instances to become healthy.

### Issue: Health checks failing
**Solution**: Ensure security groups allow traffic on port 80 from ALB to web servers.

### Issue: NAT Gateway errors
**Solution**: Ensure Elastic IP and Internet Gateway are created before NAT Gateway.

---

**Built with Terraform and AWS**
