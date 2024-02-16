output "be_ec2" {
    value = module.be_ec2.ec2_instance_public_dns
}

output "web_ec2" {
    value = module.web_ec2.ec2_instance_public_dns
}