variable "project_name" {
    description = "Project Name" 
    type = string
}

variable "sg_name" {
    description = "the name of the security group"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "ingress_rules" {
    description = "Ingress Rules"
    type = list(map(string))
}

variable "egress_rules" {
    description = "Egress Rules"
    type = list(map(string))
}
