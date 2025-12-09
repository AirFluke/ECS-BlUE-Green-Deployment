# ECS Blue Green Deployment with Terraform and CodeDeploy

This project demonstrates how to deploy an ECS service using a Blue Green deployment strategy managed through AWS CodeDeploy. The setup uses Terraform to provision infrastructure components including an ECS cluster, application load balancer, target groups, listeners, IAM roles, CodeDeploy application and deployment group, task definitions, and supporting resources.

The project also includes a Python script that registers a new task definition and triggers a CodeDeploy deployment.

---

## Project Overview

This solution provisions the following:

* ECS Cluster
* ECS Service
* EC2 launch template and autoscaling capacity provider
* Application Load Balancer
* Listener for production traffic
* Blue and green target groups
* CodeDeploy Application configured for ECS
* CodeDeploy Deployment Group for Blue Green deployments
* IAM roles required for CodeDeploy and ECS
* Python automation to register task definitions
* Optional null resource to automatically trigger deployments

---

## Infrastructure Workflow

1. Terraform creates the ECS cluster, load balancer, target groups, listeners, IAM roles, autoscaling group and capacity provider.
2. Terraform creates the CodeDeploy Application named ecs app with compute platform set to ECS.
3. Terraform creates the CodeDeploy Deployment Group which references your ECS service name, cluster name, load balancer listener, and blue and green target groups.
4. A null resource runs a Python script that registers a new task definition and triggers a CodeDeploy deployment.
5. CodeDeploy performs a Blue Green deployment, shifting traffic from the blue target group to the green target group when the new revision is ready.

---

## Common Errors and Fixes

### ClusterNotFoundException

This occurs when the cluster name in the CodeDeploy Deployment Group does not match the ECS cluster created by Terraform.
Make sure the cluster name is identical and in the same AWS region.

### ApplicationDoesNotExistException

This happens when CodeDeploy Application is not created before the Deployment Group.
Ensure that the resource aws codedeploy app ecs app has the correct region and name, and that the deployment group depends on it.

### Target group in use error

This can occur when Terraform tries to destroy a target group currently attached to a listener.
The solution is to let Terraform manage lifecycle without forcing replacement of target groups unless necessary, or manually clean up AWS resources before rerunning terraform apply.

---

## Commands to verify CodeDeploy application

```
aws deploy list applications --region eu west 2
```

You should see:

```
ecs app
```

---

## Directory Structure

* main.tf
* null python script.tf
* register task definition.py
* variables.tf
* outputs.tf

---

## Deployment Steps

1. Configure AWS credentials and ensure your CLI is set to the correct region.
2. Run terraform init to set up modules and providers.
3. Run terraform plan to review the resources that will be created.
4. Run terraform apply to build the full ECS Blue Green deployment environment.
5. Push new images to ECR and update the Python script or Terraform task definition variables to trigger deployments.
6. Use the CodeDeploy console to monitor the Blue Green rollout.

---

## Updating the Container Image

To deploy a new image:

1. Update the container image value in your Terraform ecs task definition or update the Python registration script.
2. Run terraform apply or rerun the Python script to register a new revision.
3. CodeDeploy will create a new blue green deployment pointing the green target group to the updated task revision.

---

## Requirements

* Terraform
* AWS CLI
* Python
* Botocore
* Docker and ECR for building and pushing images

