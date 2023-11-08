variable "vpc" {}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}
variable "default_vpc_route_table_id" {}
variable "tags" {}
variable "env" {}
variable "lb" {}
#variable "sg_ingress_cidr" {}  #dont declare the variable unnecessarily, this will cause issues,
#we didnt used var.sg_ingress_cidr anywhere in the roboshop-vpc which caused the issue, so commeneted the variable "sg_ingress_cidr"

variable "docdb" {}
variable "rds" {}
variable "elasticache" {}