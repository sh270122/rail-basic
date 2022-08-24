output "cluster_name" {
 value = "${aws_ecs_cluster.web-cluster.name}"   
}

output "service_name" {
    value = "${aws_ecs_service.service.name}"
}

# output "ecr_regestry_url" {
#       value = "${aws_ecr_repository.genie-poc_ecr.repository_url}"
# }