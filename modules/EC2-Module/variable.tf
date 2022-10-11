variable "project_name" {}
variable "vpc_id" {  }
variable "vpc_cidr" {}
variable "ebs_size" {
    default = "20"
}
variable "instance_type" {
  default = "t3.medium"
}