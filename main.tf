module "Networking-Module" {
  source = "./modules/Networking-Module"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
}
module "EC2-Module" {
  source = "./modules/EC2-Module"
  vpc_id = module.Networking-Module.vpc_id
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  ebs_size = var.ebs_size
  instance_type = var.instance_type
}
module "ALB-Module" {
  source = "./modules/ALB-Module"
  project_name = var.project_name
  vpc_id = module.Networking-Module.vpc_id
  security_groups = [ module.EC2-Module.default_sg_id ]
  public_subnets = [ module.Networking-Module.public-subnet-1a_id , module.Networking-Module.public-subnet-1b_id ]
  private_subnets = [ module.Networking-Module.private-subnet-1a_id , module.Networking-Module.private-subnet-1b_id ]
  ec2_template = module.EC2-Module.ec2_template_id
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
}