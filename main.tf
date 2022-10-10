module "Networking-Module" {
  source = "./modules/Networking-Module"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
}