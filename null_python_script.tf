resource "null_resource" "register_task_definition" {
  provisioner "local-exec" {
    command = "sleep 10 && python3 register_task_definition.py"
  }

  # Optional: Trigger script execution on changes to relevant resources
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [
  aws_codedeploy_deployment_group.ecs_dg,
  aws_codedeploy_app.ecs_app
]
}

/*
# Define the null resource for executing the Python script
resource "null_resource" "register_task_definition" {
  provisioner "local-exec" {
    command = <<EOT
python hey.py \
  ${var.family} \
  ${var.container_name} \
  ${var.image} \
  ${var.memory} \
  ${var.cpu} \
  ${var.role_arn} \
  ${var.deployment_group} \
  ${var.service_name}
EOT
  }

  # Specify any dependencies, e.g., if the task definition depends on an IAM role
  depends_on = [
    aws_codedeploy_app.ecs_app,
    aws_codedeploy_deployment_group.ecs_dg,
    aws_ecs_service.app
  ]
   
# Optional: Trigger script execution on changes to relevant resources
  triggers = {
    always_run = "${timestamp()}"
  }

}

*/
