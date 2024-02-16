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
    description = "VPC CIDR"
    default     = "192.168.0.0/16"
}

variable "default_route" {
    description = "Default Route"
    default     = "0.0.0.0/0"
}
