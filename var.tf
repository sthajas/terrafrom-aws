variable "environment" {} #QA/UAT/PROD

variable "instance_tenancy" {}

variable "global_azs" {
  type = list(string)
}
variable "public_subnet" {
  type = list(string)
}
variable "private_subnet" {
  type = list(string)
}
variable "vpc_cidr_block" {}

## for bastion instance

variable "bastion_ami_id" {}
variable "bastion_instance_type" {}
variable "bastion_instance_az" {}    #"us-east-1a"
variable "bastion_instance_subnetid" {}
variable "bastion_instance_keypair" {}
variable "associate_public_ip_address" {}
