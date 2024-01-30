  # main.tf

  provider "aws" {
    region = var.region  # Update with your AWS region
  }

  # Create an ECS cluster
  resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs_cluster_name
  }




 resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.ecs_task_family # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "java-app",
      "image": "${var.container_image}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 2048,
      "cpu": 1024
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 2048         # Specifying the memory our container requires
  cpu                      = 1024         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

  resource "aws_iam_role" "ecsTaskExecutionRole" {
    name               = var.ecs_execution_role_name
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
  }

  data "aws_iam_policy_document" "assume_role_policy" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
    }
  }

  resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  }
  
  resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name                             # Naming our first service
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = var.desired_count # Setting the number of containers we want deployed to 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.ecs_task_definition.family}"
    container_port   = 8080 # Specifying the container port
  }

  network_configuration {
    subnets = var.subnet_ids
    assign_public_ip = true # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group

  }
  }

  resource "aws_alb" "application_load_balancer" {
  name               = var.aws_alb_name # Naming our load balancer
  load_balancer_type = "application"
  subnets = var.subnet_ids

  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80 # Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group-java"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
  
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
  }
}


resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}
