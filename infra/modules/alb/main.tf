locals {
  common_tags = merge(var.tags, {
    project = var.project
    env     = var.env
  })
}

resource "aws_lb" "this" {
  name               = "${var.project}-${var.env}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-alb"
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.project}-${var.env}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-tg"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
