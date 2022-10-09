module "Networking-Module" {
  source = "./modules/Networking-Module"
  vpc_cidr = var.vpc_cidr
}