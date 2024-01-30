# variables.tf

variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = "java-test10-cluster"
}

variable "ecs_task_family" {
  description = "ECS task family name"
  default     = "java-test10"
}

variable "container_image" {
  description = "Docker container image"
  default     = "422571697755.dkr.ecr.ap-south-1.amazonaws.com/java-test:latest"
}

variable "ecs_execution_role_name" {
  description = "ECS task execution role name"
  default     = "ecsTaskExecutionRole10"
}

variable "ecs_service_name" {
  description = "ECS service name"
  default     = "java-test10"
}

variable "desired_count" {
  description = "Desired count of ECS tasks"
  default     = 1
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = ["subnet-0df041125fd97e373", "subnet-0ca1bee5b4efb5aa0"]
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-035fee69c51f6e2aa"
}

variable "aws_alb_name" {
  description = "VPC ID"
  default     = "java-app"
}
