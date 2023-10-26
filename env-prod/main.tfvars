components = {
  default = {
    frontend = {
      name = "frontend"
      instance_type = "t3.samll"
    }
    cart = {
      name = "cart"
      instance_type = "t3.samll"
    }
    catalogue = {
      name = "catalogue"
      instance_type = "t3.samll"
    }
    user = {
      name = "user"
      instance_type = "t3.samll"
    }
    shipping = {
      name = "shipping"
      instance_type = "t3.samll"
    }
    payment = {
      name = "payment"
      instance_type = "t3.samll"
    }
    mongodb = {
      name = "mongodb"
      instance_type = "t3.samll"
    }
    redis = {
      name = "redis"
      instance_type = "t3.samll"
    }
    mysql = {
      name = "mysql"
      instance_type = "t3.samll"
    }
    rabbitmq = {
      name = "rabbitmq"
      instance_type = "t3.samll"
    }
  }
}


security_group = [ "sg-0978f52aab0141c35" ]
zone_id =  "Z02176822VOQOIVSLJU7D"