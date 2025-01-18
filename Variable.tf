variable "access" {
  type = string
}

variable "secret" {
  type = string
}

variable "region" {
  type = string
}

##################################################
# VPC variable 
variable "VPC_cidr" {
  type = string
}
variable "VPC_name" {
  type = string
}


# public sub variable 
variable "Public_cidr" {
  type = list(string)
}
variable "public_sub_az" {
  type = list(string)
}

# Internet gateway variable
variable "VPC_internet-name" {
  type = string
}

# Route table name
variable "public_route-name" {
  type = string
}
###################################################

# ALB variable
# Alb target group variable

variable "target_type" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "target_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

# variable "tg_protocol_version" {
#   type = string
# }
# Health check variable

variable "health_path" {
  type = string
}

variable "health_protocol" {
  type = string
}

variable "health_port" {
  type = number
}

variable "healthy_threshold" {
  type = number
}

variable "unhealthy_threshold" {
  type = number
}

variable "timeout" {
  type = number
}

variable "interval" {
  type = number
}

# ALB variable

variable "load_balancer_type" {
  type = string
}

variable "LB_name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "ALB_ip_address_type" {
  type = string
}

variable "enable_deletion_protection" {
  type = bool
}

# ALB listener variable

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

# Auto-scaling variable
# Launch template variable

variable "lt_name" {
  type = string
}

variable "lt_disciption" {
  type = string
}

variable "lt_AMI" {
  type = string
}

variable "lt_instance_type" {
  type = string
}

variable "lt_public_ip" {
  type = bool
}

# Auto-scaling group variable

variable "ASG_health_check_type" {
  type = string
}

variable "ASG_health_check_grace_period" {
  type = number
}

variable "ASG_desired_capacity" {
  type = number
}

variable "ASG_max_size" {
  type = number
}

variable "ASG_min_size" {
  type = number
}


