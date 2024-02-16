resource "aws_instance" "ec2_instance" {
    instance_type   = "t2.micro"
    ami             = var.ami_id
    subnet_id       = var.subnet_id
    security_groups = [var.security_group_id]
    key_name        = var.ssh_key_name

    tags = {
        Name        = var.instance_name
        Project     = var.project_name
    }
}

