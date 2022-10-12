# terraform-aws-ha
A Terraform Module for how to run High Avalability Architecture on AWS using Terraform
![alt text](https://github.com/belalhassan91/terraform-aws-ha/blob/master/Architecture.png "Architecture")
# Example Usage
```hcl
module "ha" {
  source  = "belalhassan91/ha/aws"
  version = "1.0.4"
  project_name = "ProjectA"
  vpc_cidr = var.vpc_cidr
  region = "eu-west-1"
}
```

## The following arguments are optional:

1. region: aws target region default = "eu-central-1"

2. project_name: default = "HighAvailable"

3. vpc_cidr: default 10.0.0.0/16 

4. public_cidr : type is list and it must contain 2 record for 2 subnets. default =["10.0.0.0/24","10.0.1.0/24"]

5. private_cidr: type is list and default values is  default = ["10.0.2.0/24","10.0.3.0/24"]

6. ebs_size:  machine disk size, default = "20"

7. instance_type: ec2 machine type, default = "t3.medium"

8. max_size: autoscale max size for autoscale, default = 4

9. min_size: min size for autoscale, default = 2

10. desired_capacity: desired capacity for autoscale, default = 2
