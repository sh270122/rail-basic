provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

module "vpc" {
  source         = "./vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "securitygroups"{
  source            = "./securitygroups"
  alb_sg            = "${module.securitygroups.alb_sg}" 
  ec2_sg            = "${module.securitygroups.ec2_sg}"
  vpc_id            = "${module.vpc.vpc_id}"       
}

module "alb" {
  source         = "./alb"
  depends_on     =  [module.vpc]
  vpc_id         = "${module.vpc.vpc_id}"
  subnet1        = "${module.vpc.subnet1}"
  subnet2        = "${module.vpc.subnet2}"
  alb_sg         = "${module.securitygroups.alb_sg}"
  certificate_arn ="arn:aws:acm:us-east-1:561866774576:certificate/fddc3992-9840-4967-87fc-5d29c7723e87"
}

module "autoscaling" {
  source              = "./autoscaling"
  depends_on          =  [module.alb]
  ecs_ami             = "ami-040d909ea4e56f8f3"
  cluster_name        = "rails-cluster"
  instance_type       = "t2.micro"
  key_name            = "rails-poc"
  target_group_arn    = "${module.alb.alb_target_group_arn}"
  vpc_id              = "${module.vpc.vpc_id}"
  pri_ec2_sg_id       = "${module.securitygroups.pri_ec2_sg}"
  private-sub1        = "${module.vpc.private_subnet1}"
  private-sub2        = "${module.vpc.private_subnet2}"
}

  module "ecs" {
   source            = "./ecs"
   depends_on        =  [module.autoscaling]
   cluster_name      = "rails-cluster"
   container_port    = 80
   image_name        = "561866774576.dkr.ecr.us-east-1.amazonaws.com/rail-poc:latest"
   tg_arn            = "${module.alb.alb_target_group_arn}"
 }

 module "route53" {
  source            = "./route53"
  zone_id ="Z35SXDOTRQ7X7K"
  alb_name ="${module.alb.alb_dns_name}"
  zone-id="Z03636692NNBFJH1EUACN"
 }

/*
module ecsAutoscaling{
  source                     =  "./ecsAutoscaling"
  depends_on                 =  [module.ecs]
  ecs_cluster_name           =  "${module.ecs.cluster_name}"
  ecs_service_name           =  "${module.ecs.service_name}"
  scale_target_max_capacity  =  5 
  scale_target_min_capacity  =  1
  max_cpu_threshold          =  75
  max_cpu_evaluation_period  =  2
  max_cpu_period             =  60
  min_cpu_threshold          =  40
  min_cpu_evaluation_period  =  3
  min_cpu_period             =  60
}


module "ec2_Bastion" {
   source             = "./ec2_Bastion"
   depends_on         = [module.autoscaling]
   jumphost_ami       = "ami-0747bdcabd34c712a"
   instance_type      = "t2.micro" 
   ec2_sg_id          = "${module.securitygroups.ec2_sg}"
   pub_subnet         = "${module.vpc.subnet1}"
   key_name           = "rails-key"
}
*/
/*module "rds" {
  source      = "./rds"
  db_instance = "db.t2.micro"
  rds_subnet1 = "${module.vpc.private_subnet1}"
  rds_subnet2 = "${module.vpc.private_subnet2}"
  vpc_id      = "${module.vpc.vpc_id}"
  rds_sg      = "${module.securitygroups.rds_sg}"
}

*/
