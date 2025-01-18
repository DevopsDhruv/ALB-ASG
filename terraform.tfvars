
region = "ap-south-1"

###########################################
# VPC variable value
VPC_cidr = "10.0.0.0/16"
VPC_name = "VPC-one"

# Public subnet
Public_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
public_sub_az = ["ap-south-1a", "ap-south-1b"]


# Internet gateway
VPC_internet-name = "VPC-internet"

# Public Route table
public_route-name = "Public-route"
##########################################

# ALB variable value
# Alb target group variable
target_type       = "instance"
target_group_name = "ALB-target-group"
target_port       = 80
tg_protocol       = "HTTP"
# tg_protocol_version = "HTTP1"

# Health check variable value
health_path         = "/"
health_protocol     = "HTTP"
health_port         = 80
healthy_threshold   = 2
unhealthy_threshold = 2
timeout             = 5
interval            = 30

# ALB variable value
load_balancer_type         = "application"
LB_name                    = "ALB"
internal                   = false
ALB_ip_address_type        = "ipv4"
enable_deletion_protection = false

# ALB Listener
listener_port     = 80
listener_protocol = "HTTP"

##########################################


# ASG variable value
# launch template variable value
lt_name          = "ALB-target-group"
lt_disciption    = "ALB target group"
lt_AMI           = "ami-00bb6a80f01f03502"
lt_instance_type = "t2.micro"
lt_public_ip     = true

# Auto-scaling group variable value

ASG_health_check_type         = "EC2"
ASG_health_check_grace_period = 300
ASG_desired_capacity          = 2
ASG_max_size                  = 4
ASG_min_size                  = 2
##########################################
