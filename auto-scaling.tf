# Creating Instance key

resource "aws_key_pair" "Instance_key" {
  key_name   = "Instance_key"
  public_key = file("${path.module}/instance_key.pub")
}


resource "aws_launch_template" "test-lt" {
  name_prefix   = var.lt_name
  description   = var.lt_disciption
  image_id      = var.lt_AMI # AMI ID
  instance_type = var.lt_instance_type
  key_name      = aws_key_pair.Instance_key.key_name

  network_interfaces {
    associate_public_ip_address = var.lt_public_ip
    security_groups             = [aws_security_group.public_sg.id]
  }

  #  If you specify block_device_mappings, it will create the specified EBS volumes in addition to the root volume
  # block_device_mappings {
  #     device_name = "/dev/sda1"
  #     ebs {
  #         volume_size = 8
  #         volume_type = "gp2"
  #         delete_on_termination = true
  #         #iops = 100
  #         encrypted = false
  #     }
  # }


  #   lifecycle {
  #     prevent_destroy = false #  If set to true, Terraform will prevent the resource from being destroyed. This is useful for critical resources that should not be accidentally deleted.
  #     ignore_changes = [ vpc_security_group_ids ] # Specifies a list of resource attributes to ignore changes to. This is useful for attributes that are managed outside of Terraform or that should not trigger updates.
  #     create_before_destroy = true #  If set to true, Terraform will create a new resource before destroying the old one. This is useful for resources that need to maintain availability during updates.
  #   }

  user_data = filebase64("userdata.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "example-instance"
    }
  }
}

resource "aws_autoscaling_group" "test-asg" {
  launch_template {
    id      = aws_launch_template.test-lt.id
    version = "$Latest"
  }


  vpc_zone_identifier = [aws_subnet.Public-sub[0].id, aws_subnet.Public-sub[1].id]
  #load_balancers = [  ]
  health_check_type         = var.ASG_health_check_type
  health_check_grace_period = var.ASG_health_check_grace_period
  desired_capacity          = var.ASG_desired_capacity
  max_size                  = var.ASG_max_size
  min_size                  = var.ASG_min_size

  target_group_arns = [aws_lb_target_group.ALB_target_group.arn]


  tag {
    key                 = "Name"
    value               = "example-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                      = "scale-in-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300 # This warm-up period allows the new instance to start up and begin handling traffic before it is considered fully operational.
  autoscaling_group_name    = aws_autoscaling_group.test-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                      = "scale-out-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name    = aws_autoscaling_group.test-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

# How Target Tracking Policies Work Together: -

# Scale-In Policy: This policy will attempt to scale in (reduce the number of instances) to maintain an average CPU utilization of 30%.
# If the CPU utilization is above 30%, this policy will not trigger a scale-in action.

# Scale-Out Policy: This policy will attempt to scale out (increase the number of instances) to maintain an average CPU utilization of 70%.
# If the CPU utilization is below 70%, this policy will not trigger a scale-out action.

# Scenario: CPU Utilization at 50%
# Scale-In Policy: The CPU utilization is above the target value of 30%, so the scale-in policy will not trigger a scale-in action.
# Scale-Out Policy: The CPU utilization is below the target value of 70%, so the scale-out policy will not trigger a scale-out action.