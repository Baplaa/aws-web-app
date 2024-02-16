provider "aws" {
    region               = var.aws_region
}

resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    instance_tenancy     = "default"
    enable_dns_hostnames = true

    tags = {
        Name    = var.vpc_name
        Project = var.project_name
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name    = "Internet Gateway"
        Project = var.project_name
    }
}

resource "aws_route_table" "rt" {
    vpc_id               = aws_vpc.vpc.id

    route {
        cidr_block = var.default_route
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name    = "Route Table"
        Project = var.project_name
    }
}

