
output "load_balancer" {
  value = "${module.alb.alb_dns_name}"
} 

# output "ecr_url" {
#   value = "${module.ecs.ecr_regestry_url}"
# }

# output "rds_endpoint" {
#   value = "${module.rds.ws_db_instance.genie-poc-sql.endpoint}"
#   }
  