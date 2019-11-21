resource "aws_security_group" "lb-sg" {
    name        = "${var.environment}-${var.component_name}-lb-sg"
    description = "controls access to the ALB"
    vpc_id      = module.vpc.vpc_id

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = split(",", data.aws_ssm_parameter.inbound_ips.value)
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-${var.component_name}-lb-sg"
    }
}

resource "aws_security_group" "buildmonitor-sg" {
    vpc_id    = module.vpc.vpc_id
    name      = "${var.environment}-${var.component_name}-buildmonitor-sg"

    ingress {
        protocol        = "tcp"
        from_port       = "8080"
        to_port         = "8080"
        security_groups = [aws_security_group.lb-sg.id]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-${var.component_name}-buildmonitor-sg"
    }
}