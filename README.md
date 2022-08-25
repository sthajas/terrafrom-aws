## TODO
1. create VPC
    a. PROD
    b. UAT
    c. STAGE
2. create subnet
    a. private subnet - natgateway
    b. public subnet  - internet gateway
3. Two bastion host
    a. prod - private subnet
    b. stage + uat  - private subnet
4. Create ec2 instance in QA-VPC with private IP
5. public and private LB 



# Steps to Follow

1. use workspaces
    - terraform workspace new qa # qa/uat/prod
    - terraform plan  -var-file tfvars/qa.tfvars
    - terraform apply  -var-file tfvars/qa.tfvars

2. to remove the specific resources
    - ex - terraform destroy --target=aws_subnet.PRIVATE-SUBNET-1B -var-file tfvars/uat.tfvars

