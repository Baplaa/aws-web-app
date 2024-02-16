# Create a03_vpc
module "vpc" {
    source          = "./modules/terraform_vpc_simple"
    project_name    = var.project_name
    vpc_name        = var.vpc_name
    vpc_cidr        = var.vpc_cidr
    aws_region      = var.aws_region
}

# Create db_2 Subnet
module "db_2_sn" {
    source          = "./modules/terraform_sn_simple"
    sn_name         = "db_2"
    az              = "b"
    sn_cidr         = var.db_2_sn_cidr
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id
}

# Create db_2 Route Table Association
resource "aws_route_table_association" "db_2_rt" {
    subnet_id       = module.db_2_sn.sn_id
    route_table_id  = module.vpc.rt_id
}

# Create db_1 Subnet
module "db_1_sn" {
    source          = "./modules/terraform_sn_simple"
    sn_name         = "db_1"
    az              = "a"
    sn_cidr         = var.db_1_sn_cidr
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id
}

# Create db_1 Route Table Association
resource "aws_route_table_association" "db_1_rt" {
    subnet_id       = module.db_1_sn.sn_id
    route_table_id  = module.vpc.rt_id
}

# Create db_1 Subnet Security Group
module "db_1_sn_sg" {
    source          = "./modules/terraform_sg_simple"
    sg_name         = "db_1"
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id

    ingress_rules   = [
        {
            rule_name   = "be_3306_from"
            ip_protocol = "tcp"
            cidr_ipv4   = var.be_sn_cidr
            from_port   = 3306
            to_port     = 3306
        }
    ]

    egress_rules    = [
        {
            rule_name   = "be_3306_to"
            ip_protocol = "-1"
            cidr_ipv4   = var.be_sn_cidr
            from_port   = 3306
            to_port     = 3306
        }
    ]
}

# Create be Subnet
module "be_sn" {
    source          = "./modules/terraform_sn_simple"
    sn_name         = "be"
    az              = "a"
    sn_cidr         = var.be_sn_cidr
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id
}

# Create be Route Table Association
resource "aws_route_table_association" "be_rt" {
    subnet_id       = module.be_sn.sn_id
    route_table_id  = module.vpc.rt_id
}

# Create be Subnet Security Group
module "be_sn_sg" {
    source          = "./modules/terraform_sg_simple"
    sg_name         = "be"
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id

    ingress_rules   = [
        {
            rule_name   = "ssh_bcit"
            ip_protocol = "tcp"
            cidr_ipv4   = var.bcit_net
            from_port   = 22
            to_port     = 22
        },
        {
            rule_name   = "ssh_home"
            ip_protocol = "tcp"
            cidr_ipv4   = var.home_net
            from_port   = 22
            to_port     = 22
        },
        {
            rule_name   = "vpc_traffic"
            ip_protocol = "-1"
            cidr_ipv4   = var.vpc_cidr
            from_port   = 0
            to_port     = 0
        }
    ]

    egress_rules    = [
        {
            rule_name   = "any_dest_protocol"
            ip_protocol = "-1"
            cidr_ipv4   = "0.0.0.0/0"
            from_port   = 0
            to_port     = 0
        }
    ]
}

# Create web Subnet
module "web_sn" {
    source          = "./modules/terraform_sn_simple"
    sn_name         = "web"
    az              = "a"
    sn_cidr         = var.web_sn_cidr
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id
}

# Create web Route Table Association
resource "aws_route_table_association" "web_rt" {
    subnet_id       = module.web_sn.sn_id
    route_table_id  = module.vpc.rt_id
}

# Create web Subnet Security Group
module "web_sn_sg" {
    source          = "./modules/terraform_sg_simple"
    sg_name         = "web"
    project_name    = var.project_name
    vpc_id          = module.vpc.vpc_id

    ingress_rules   = [
        {
            rule_name   = "https"
            ip_protocol = "tcp"
            cidr_ipv4   = var.default_route
            from_port   = 443
            to_port     = 443
        },
        {
            rule_name   = "http"
            ip_protocol = "tcp"
            cidr_ipv4   = var.default_route
            from_port   = 80
            to_port     = 80
        },
        {
            rule_name   = "ssh_bcit"
            ip_protocol = "tcp"
            cidr_ipv4   = var.bcit_net
            from_port   = 22
            to_port     = 22
        },
        {
            rule_name   = "ssh_home"
            ip_protocol = "tcp"
            cidr_ipv4   = var.home_net
            from_port   = 22
            to_port     = 22
        },
        {
            rule_name   = "be_traffic"
            ip_protocol = "-1"
            cidr_ipv4   = var.be_sn_cidr
            from_port   = 0
            to_port     = 0
        }
    ]

    egress_rules    = [
        {
            rule_name   = "any_dest_protocol"
            ip_protocol = "-1"
            cidr_ipv4   = "0.0.0.0/0"
            from_port   = 0
            to_port     = 0
        }
    ]
}

# Create be EC2 Instance
module "be_ec2" {
    source              = "./modules/terraform_ec2_simple" 
    instance_name       = "be_ec2"
    project_name        = var.project_name 
    aws_region          = var.aws_region
    ami_id              = var.ami_id
    subnet_id           = module.be_sn.sn_id
    security_group_id   = module.be_sn_sg.sg_id
    ssh_key_name        = var.ssh_key_name
}

# Create web EC2 Instance
module "web_ec2" {
    source              = "./modules/terraform_ec2_simple"
    instance_name       = "web_ec2"
    project_name        = var.project_name
    aws_region          = var.aws_region
    ami_id              = var.ami_id
    subnet_id           = module.web_sn.sn_id
    security_group_id   = module.web_sn_sg.sg_id
    ssh_key_name        = var.ssh_key_name
}

# Create RDS Subnet Group
resource "aws_db_subnet_group" "db_sg_group" {
    name            = "rds_group"
    subnet_ids      = [
        module.db_1_sn.sn_id,
        module.db_2_sn.sn_id
    ]

    tags = {
        Name = "RDS Group" 
    }   
}

# Create RDS EC2 Instance
resource "aws_db_instance" "rds_ec2" {
    engine                  = "mysql"
    instance_class          = "db.t2.micro"
    allocated_storage       = "5"
    skip_final_snapshot     = true 
    db_name                 = "rds_ec2"
    username                = "root"
    password                = "rootpass123"
    db_subnet_group_name    = aws_db_subnet_group.db_sg_group.name 
    vpc_security_group_ids = [module.db_1_sn_sg.sg_id]

    tags = {
        Name    = "rds_ec2"
        Project = var.project_name
    }
}