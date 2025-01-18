# Creating ALB Target Group

resource "aws_lb_target_group" "ALB_target_group" {
  target_type = var.target_type
  name        = var.target_group_name
  port        = var.target_port
  protocol    = var.tg_protocol
  vpc_id      = aws_vpc.VPC-one.id

  #protocol_version = "HTTP1"

  health_check {
    path                = var.health_path         # The path where the health check is sent.
    protocol            = var.health_protocol     # The protocol used to perform the health check.
    port                = var.health_port         # The port on which the health check is sent.
    healthy_threshold   = var.healthy_threshold   # if the target passes two consecutive health checks, it's marked as healthy.
    unhealthy_threshold = var.unhealthy_threshold # if the target fails two consecutive health checks, it's marked as unhealthy.
    timeout             = var.timeout             # if the target doesn't respond within 5 seconds, it's marked as unhealthy. 
    interval            = var.interval            # if the interval is set to 30 seconds, the load balancer will send a health check request every 30 seconds.
  }
}

# Creating ALB

resource "aws_lb" "ALB" {
  load_balancer_type = var.load_balancer_type
  name               = var.LB_name
  internal           = var.internal
  ip_address_type    = var.ALB_ip_address_type
  subnets            = [aws_subnet.Public-sub[0].id, aws_subnet.Public-sub[1].id]
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = var.enable_deletion_protection
}

# Creating ALB Listener

resource "aws_lb_listener" "ALB_listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB_target_group.arn
  }
}

output "ALB_DNS" {
  value = aws_lb.ALB.dns_name
}