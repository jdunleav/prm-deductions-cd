resource "aws_alb" "alb" {
  name            = "${var.environment}-${var.component_name}-alb"
  subnets         = "${module.vpc.public_subnets}"

  security_groups = ["${aws_security_group.lb-sg.id}"]
}

resource "aws_alb_target_group" "alb-tg" {
  name        = "${var.environment}-${var.component_name}-alg-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = "${module.vpc.vpc_id}"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb-tg.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "buildmonitor1" {
  target_group_arn = "${aws_alb_target_group.alb-tg.arn}"
  target_id        = "${aws_instance.buildmonitor.id}"
  port             = 8080
}