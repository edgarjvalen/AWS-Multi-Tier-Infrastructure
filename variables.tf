variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet in us-east-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet in us-east-1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet in us-east-1a"
  type        = string
  default     = "10.0.10.0/24"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone_1a" {
  description = "Availability zone 1a"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_1b" {
  description = "Availability zone 1b"
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-011899242bb902164"  # Amazon Linux 2
}

variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
  default     = "50.113.74.152/32"
}

variable "project_name" {
  description = "Project name for resource tags"
  type        = string
  default     = "multi-tier-web-app"
}