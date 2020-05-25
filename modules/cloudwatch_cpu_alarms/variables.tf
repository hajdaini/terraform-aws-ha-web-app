variable "prefix_name" {}

variable "max_cpu_percent_alarm" {
	description = "percentage of CPU consumption to achieve scale up"
	default 	= 80
}

variable "min_cpu_percent_alarm" {
	description = "percentage of CPU consumption to achieve scale down"
	default 	= 5
}

variable "asg_name" {
	description = "ASG name used to increase or decrease ec2 instances"
}