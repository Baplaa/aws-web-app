provider "aws" {
    region = var.aws_region
}

variable "aws_region" {
    description = "AWS Region"
    default     = "us-west-2"
}

variable "project_name" {
    description = "Project Name"
}

variable "instance_name" {
    description = "EC2 Name"
}

variable "subnet_id" {
    description = "Target Subnet"
}

variable "security_group_id" {
    description = "Target Security Group"
}

variable "ami_id" {
    description = "AMI Instance ID"
}

variable "ssh_key_name" {
    description = "SSH Key"
    default     = "acit_4640"
}
