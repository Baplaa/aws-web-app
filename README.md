![AWS Web App](https://github.com/Baplaa/aws-web-app/blob/main/assets/aws_web_app.png)

# Full-Stack AWS Web App

Using Terraform and Ansible, this web application displays any RDS-injected student name and student ID on a web page.

Flask project files are sourced from my former professor's GitHub [here](https://github.com/timoguic/acit4640-py-mysql/)

## Table of Contents
1. [Background](#background)
2. [Guide](#guide)
3. [Infrastructure and Server Setup](#infrastructure-and-server-setup)
4. [Technologies Used](#technologies-used)

## Background

A simple, full-stack web application fully provisioned using Terraform Modules for the infrastructure and an Ansible Playbook for Host server setups.

## Guide

REQUIRED STEPS:
1. copy the directory using `cp -r /local/machine/path/to/my/project /dest/path`
    * do NOT use `sudo`!!
    * if terraform complains about having no permissions, try `sudo chmod 777 -R` on the project directory after `cp` 
        - THIS SPECIFIC INSTANCE OF `sudo` LEADS TO PROBLEMS LATER!! (see step 4) 
      ...refrain from doing it!!
2. cd to `backend_setup`
    - run `terraform init`
    - run `terraform apply --auto-approve`
3. cd to `infra`
    - run `terraform init`
    - run `terraform apply --auto-approve`
    * this takes a while because of RDS, please be patient!!
4. cd to `service`
    - run `ansible-playbook setup.yaml`
    * if you ended up running it as `sudo`, the playbook will complain and say that it won't:
        - recognize ansible.cfg
        - fail to see hosts in inventory
      I am unsure what causes this other than `sudo` and the ansible directory is too "open" as such
5. visit web DNS to view webapp
    * found as an output of step 3 above
    * you should see my full name and student ID when visiting the site!

CLEANUP:
1. cd to `infra`
    - run `terraform destroy`
    - enter `yes`
    * this takes a while because of RDS, please be patient!!
2. cd to `backend_setup`
    - run `terraform destroy`
    - enter `yes`

NOTES:
1. this project assumes you have the following:
    - ssh key at `~/.ssh/acit_4640`
    - ssh key `acit_4640` in AWS EC2
        * us-west-2 (US West Oregon)
    - home IP address (/16) OR range (/24)
        * configurable in `./infra/terraform.tfvars` on `line 10`
    - student name and student ID
        * configurable in `./service/roles/data_injection/main.yaml` on `line 56`
        * `name` has a character limit of `30`
        * `bcit_id` has a character limit of `10`

## Infrastructure and Server Setup

![Infrastructure Diagram](https://github.com/Baplaa/aws-web-app/blob/main/assets/infrastructure.png)

The creation of the infrastructure consists of the following AWS resources separated by Modules:
- S3 Bucket
- RDS
- VPC
- Subnets
- Route Table
- Security Groups
- EC2 Instances

The configuration of the host servers from a dynamic host inventory consists of 4 roles—each with appropriate handlers—in a single Ansible Playbook:
**Role**  | **Description**
------------- | -------------
be  | *Installs backend and python dependencies for Backend Host, clones Flask project files, configures MYSQL to RDS Host, and creates and starts a new Service*
data_injection  | *Installs database dependencies for Backend Host, creates database / user / table, and injects student data to RDS Host*
tools  | *Installs base dependencies for Backend and Web Hosts*
web  | *Installs web dependencies for Web Host, configures NGiNX proxy, clones Flask project files, and serves index.html*

## Technologies Used
- [Amazon Web Services](https://aws.amazon.com/) - *cloud solution for web application*
- [Ansible](https://www.ansible.com/) - *provisioning automation solution for Host servers*
- [DynamoDB](https://aws.amazon.com/dynamodb/) - *data storage solution*
- [Flask](https://www.geeksforgeeks.org/flask-tutorial/) - *framework for web application provided by former professor*
- [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML) - *language used for web development*
- [Terraform](https://www.terraform.io/) - *provisioning automation for infrastructure*
