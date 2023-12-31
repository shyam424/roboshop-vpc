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

#---------------------------------------------------load balancer
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

#-----------------------------------------------------Databases
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
  engine_family           = each.value["engine_family"]
  instance_count          = each.value["instance_count"]
  instance_class           = each.value["instance_class"]
}


module "rds" {

  source                     = "git::https://github.com/shyam424/tf-module-rds.git"
  tags                       = var.tags
  env                        = var.env

  for_each                   = var.rds
  subnet_ids                 = local.db_subnets
  vpc_id                     = local.vpc_id
  sg_ingress_cidr            = local.app_subnets_cidr
  rds_type                   = each.value ["rds_type"]
  db_port                    = each.value ["db_port"]
  engine_family              = each.value ["engine_family"]
  engine                     = each.value ["engine"]
  engine_version             = each.value ["engine_version"]
  backup_retention_period    = each.value ["backup_retention_period"]
  preferred_backup_window     = each.value ["preferred_backup_window"]
  skip_final_snapshot        = each.value ["skip_final_snapshot"]
  instance_count             = each.value ["instance_count"]
  instance_class           = each.value ["instance_class"]

}


module "elasticache" {

  source                     = "git::https://github.com/shyam424/tf-module-elasticcache.git"
  tags                       = var.tags
  env                        = var.env

  for_each                   = var.elasticache

  subnet_ids                 = local.db_subnets
  vpc_id                     = local.vpc_id
  sg_ingress_cidr            = local.app_subnets_cidr
  elasticache_type           = each.value ["elasticache_type"]
  family                     = each.value ["family"]
  port                       = each.value ["port"]
  engine                     = each.value ["engine"]
  node_type                  = each.value ["node_type"]
  num_cache_nodes            = each.value ["num_cache_nodes"]
  engine_version             = each.value ["engine_version"]
}



#output which is available in the main terraform code we call it as printing
#all the variables which are available in the tf-module-rds/vars.tf should present in the roboshop-vpc/maintf


module "rabbitmq" {

  source                     = "git::https://github.com/shyam424/tf-module-rabbitmq.git"
  tags                       = var.tags
  env                        = var.env
  zone_id                    = var.zone_id

  for_each                   = var.rabbitmq

  subnet_ids                 = local.db_subnets
  vpc_id                     = local.vpc_id
  sg_ingress_cidr            = local.app_subnets_cidr
  ssh_ingress_cidr           = var.ssh_ingress_cidr
  instance_type              = each.value ["instance_type"]

}


#------------------------------------APP
module "app" {
  source = "git::https://github.com/shyam424/tf-module-app.git"

#-direct variables
  tags                       = var.tags
  env                        = var.env
  zone_id                    = var.zone_id
  ssh_ingress_cidr           = var.ssh_ingress_cidr
  default_vpc_id             = var.default_vpc_id

#-loop related things
  for_each            = var.apps
  component           = each.key
  port                = each.value["port"]
  instance_type       = each.value["instance_type"]
  desired_capacity   = each.value["desired_capacity"]
  max_size           = each.value["max_size"]
  min_size           = each.value["min_size"]
  lb_priority        = each.value["lb_priority"]

#-local variables
  sg_ingress_cidr     = local.app_subnets_cidr
  vpc_id              = local.vpc_id
  subnet_ids          = local.app_subnets


  #alb (in the videos) has been modified as lb in our script
  private_lb_name            = lookup(lookup(lookup(module.lb, "private", null), "lb", null), "dns_name", null)
  private_listener           = lookup(lookup(lookup(module.lb, "private", null), "listener", null), "arn", null)

  public_lb_name            = lookup(lookup(lookup(module.lb, "public", null), "lb", null), "dns_name", null)
  public_listener           = lookup(lookup(lookup(module.lb, "public", null), "listener", null), "arn", null)
}


