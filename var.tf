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


# variable "uat_public_subnet" {
#   type = list(string)
#   default = ["10.20.1.0/24","10.20.2.0/24"]
# }
# variable "uat_private_subnet" {
#   type = list(string)
#   default = ["10.20.3.0/24","10.20.4.0/24"]
# }
# variable "prod_public_subnet" {
#   type = list(string)
#   default = ["10.30.1.0/24","10.30.2.0/24"]
# }
# variable "prod_private_subnet" {
#   type = list(string)
#   default = ["10.30.3.0/24","10.30.4.0/24"]
# }

# ### VPC ###
# variable "region" {}

# variable "qa_vpc_cidr_block" {}
# variable "uat_vpc_cidr_block" {}
# variable "prod_vpc_cidr_block" {}

# variable "instance_tenancy" {} # default

# variable "qa_vpc_name" {} ## QA_VPC
# variable "uat_vpc_name" {}
# variable "prod_vpc_name" {}

# QA ENV ##
# SUBNET ##
# variable "qa_public_subnet1a_cidr_block" {}
# variable "qa_public_subnet1b_cidr_block" {}
# variable "qa_private_subnet1a_cidr_block" {}
# variable "qa_private_subnet1b_cidr_block" {}
# 
# UAT ENV ##
# SUBNET ##
# variable "uat_public_subnet1a_cidr_block" {}
# variable "uat_public_subnet1b_cidr_block" {}
# variable "uat_private_subnet1a_cidr_block" {}
# variable "uat_private_subnet1b_cidr_block" {}
# 
# PROD ENV ##
# SUBNET ##
# variable "prod_public_subnet1a_cidr_block" {}
# variable "prod_public_subnet1b_cidr_block" {}
# variable "prod_private_subnet1a_cidr_block" {}
# variable "prod_private_subnet1b_cidr_block" {}
# 
#######
