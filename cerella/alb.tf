#
# @author GDev
# @date May 2022
#

resource "aws_lb" "ingress" {
  internal           = var.alb-privacy
  load_balancer_type = "application"
  name               = var.cluster-name
  security_groups    = [var.security-group-id]
  subnets            = var.subnets
  idle_timeout       = 300
}

resource "aws_alb_listener" "https_to_workers" {
  certificate_arn   = var.acm-certificate-arn
  load_balancer_arn = aws_lb.ingress.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_alb_target_group.workers.arn
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.workers]
}

resource "aws_alb_target_group" "workers" {
  name     = "eks-workers-${var.cluster-name}"
  port     = var.cluster-ingress-port
  protocol = "HTTP"
  vpc_id   = var.vpc-id
}

resource "aws_autoscaling_attachment" "workers" {
  lb_target_group_arn    = aws_alb_target_group.workers.arn
  autoscaling_group_name = aws_autoscaling_group.workers.id
}
