module "vpc" {

  source    = "git::https://github.com/shyam424/tf-module-vpc.git"
  for_each  = var.vpc
  cidr = each.value["cidr"]
  subnets = each.value["subnets"]

}


output "vpc" {
  value = module.vpc
}

#output which is available in the main terraform code we call it as printing


