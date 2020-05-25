

# scale up alarm
resource "aws_autoscaling_policy" "my-cpu-policy-scaleup" {
  name                   = "my-cpu-policy-scaleup"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

# cpu metric config to scale up
resource "aws_cloudwatch_metric_alarm" "my-cpu-alarm" {
  alarm_name          = "${var.prefix_name}-cpu-alarm"
  alarm_description   = "${var.prefix_name}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.max_cpu_percent_alarm

  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.my-cpu-policy-scaleup.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "my-cpu-policy-scaledown" {
  name                   = "${var.prefix_name}-cpu-policy-scaledown"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = 300
  policy_type            = "SimpleScaling"
}

# cpu metric config to scale down
resource "aws_cloudwatch_metric_alarm" "my-cpu-alarm-scaledown" {
  alarm_name          = "${var.prefix_name}-cpu-alarm-scaledown"
  alarm_description   = "${var.prefix_name}-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.min_cpu_percent_alarm

  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.my-cpu-policy-scaledown.arn]
}

# # Uncomment if you want to have autoscaling notifications
# resource "aws_sns_topic" "my-sns" {
#  name         = "${var.prefix_name}-asg-sns"
#  display_name = "my ASG SNS topic"
# } 

# # email subscription is currently unsupported in terraform and can be done using the AWS Web Console
# resource "aws_autoscaling_notification" "my-notify" {
#  group_names = ["${var.asg_name}"]
#  topic_arn     = "${aws_sns_topic.my-sns.arn}"
#  notifications  = [
#    "autoscaling:EC2_INSTANCE_LAUNCH",
#    "autoscaling:EC2_INSTANCE_TERMINATE",
#    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
#  ]
# }
