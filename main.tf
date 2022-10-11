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