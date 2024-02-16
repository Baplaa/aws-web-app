variable "aws_region" {
    description = "AWS Region"
    default     = "us-west-2"
}

variable "project_name" {
    description = "Project Name"
}

variable "vpc_name" {
    description = "VPC Name"
}

variable "vpc_cidr" {
    description = "VPC CIDR Block"
    default     = "192.168.0.0/16"   
}

variable "db_1_sn_cidr" {
    description = "db_1 Subnet CIDR Block"
}

variable "db_2_sn_cidr" {
    description = "db_2 Subnet CIDR Block"
}

variable "be_sn_cidr" {
    description = "be Subnet CIDR Block"
}

variable "web_sn_cidr" {
    description = "web Subnet CIDR Block"
}

variable "default_route" {
    description = "Default Route"
    default     = "0.0.0.0/0"
}

variable "home_net" {
    description = "Home Network"
}

variable "bcit_net" {
    description = "BCIT Network"
}

variable "ami_id" {
    description = "AMI Instance ID"
}

variable "ssh_key_name" {
    description = "SSH Key"
    default     = "acit_4640"
}