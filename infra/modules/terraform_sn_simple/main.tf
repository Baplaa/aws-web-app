resource "aws_subnet" "sn" {
    vpc_id                    = var.vpc_id
    cidr_block                = var.sn_cidr
    availability_zone         = format("%s%s",var.aws_region,var.az)
    map_public_ip_on_launch   = true

    tags = {
        Name                  = var.sn_name
        Project               = var.project_name
    }
}