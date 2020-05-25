variable "prefix_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list
}

variable "public_subnet_ids" {
  type = list
}

variable "webserver_port" {
	default = 80
}

variable "webserver_protocol" {
	default = "HTTP"
}

variable "user_data" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "role_profile_name" {}


variable "min_instance" {
  description = "minimum number of instances for your ASG"
  default     = 2
}

variable "desired_instance" {
  description = "starting number of instances for your ASG"
  default     = 2
}

variable "max_instance" {
  description = "maximum number of instances for your ASG"
  default     = 4
}

variable "ami" {}

variable "path_to_public_key" {
  description = "relatif or absolute path of your public ssh key"
}