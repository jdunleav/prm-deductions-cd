resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.environment}-${var.component_name}-ecs-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "buildmonitor"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::327778747031:role/ecsTaskExecutionRoleWithCodePipeline"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/deductions-dashboard:latest",
    
    "memory": 512,
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "buildmonlogs",
            "awslogs-region": "eu-west-2",
            "awslogs-stream-prefix": "awslogs-example"
        }
    },
    "environment" : [
      { "name" : "AWS_DEFAULT_REGION", "value" : "eu-west-2" }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.environment}-${var.component_name}-ecs-service"
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "2"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs-tasks-sg.id}"]
    subnets         = "${module.vpc.private_subnets}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alg-tg.arn}"
    container_name   = "app"
    container_port   = "8080"
  }

  depends_on = [
    "aws_alb_listener.alg-listener",
  ]
}