environment = "UAT"
instance_tenancy = "default"
vpc_cidr_block = "10.20.0.0/16"
global_azs = ["us-east-1a","us-east-1b"]
public_subnet = ["10.20.1.0/24","10.20.2.0/24"]
private_subnet = ["10.20.3.0/24","10.20.4.0/24"]

bastion_ami_id = "ami-052efd3df9dad4825"
bastion_instance_type = "t1.micro"
bastion_instance_az = "us-east-1a"
bastion_instance_subnetid = "UAT-PUBLIC-SUBNET-1A" 
bastion_instance_keypair = "terraform-test"
associate_public_ip_address = "true
