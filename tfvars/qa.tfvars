environment = "QA"
instance_tenancy = "default"
vpc_cidr_block = "10.10.0.0/16"
global_azs = ["us-east-1a","us-east-1b"]
public_subnet = ["10.10.1.0/24","10.10.2.0/24"]
private_subnet = ["10.10.3.0/24","10.10.4.0/24"]

instance_type_def = "ami-052efd3df9dad4825"
instace_image_id = "t1.micro"
instace_key_name =  "terraform-test"


