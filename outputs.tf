
output "vpc" {
  value = data.aws_subnets.subnets.ids
}


output "lb" {
  value = lookup(lookup(lookup(module.lb, "private", null), "lb", null), "dns_name", null)
}