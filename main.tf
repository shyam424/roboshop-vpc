module "vpc" {

  source                     = "git::https://github.com/shyam424/tf-module-vpc.git"
  for_each                   = var.vpc
  cidr                       = each.value["cidr"]
  subnets                    = each.value["subnets"]
  default_vpc_id             = var.default_vpc_id
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags                       = var.tags
  env                        = var.env

}


module "lb" {

  source                     = "git::https://github.com/shyam424/tf-module-lb.git"
  for_each                   = var.lb
  internal                   = each.value["internal"]
  lb_type                    = each.value["lb_type"]
  sg_ingress_cidr            = each.value["sg_ingress_cidr"]
  vpc_id                     = each.value["internal"] ? local.vpc_id : var.default_vpc_id  #check terrafrom conditions
  subnets                    = each.value["internal"] ?  local.app_subnets : data.aws_subnets.subnets.ids
  tags                       = var.tags
  env                        = var.env
  sg_port                    = each.value ["sg_port"]

}


module "docdb" {

  source                     = "git::https://github.com/shyam424/tf-module-docdb.git"
  tags                       = var.tags
  env                        = var.env

  for_each                   = var.docdb
  subnet_ids                 = local.db_subnets
  backup_retention_period =  each.value ["backup_retention_period"]
  preferred_backup_window =  each.value ["preferred_backup_window"]
  skip_final_snapshot     =  each.value ["skip_final_snapshot"]
  vpc_id                  = local.vpc_id
  sg_ingress_cidr         = local.app_subnets_cidr
  engine_version          = each.value["engine_version"]
}

#output which is available in the main terraform code we call it as printing


