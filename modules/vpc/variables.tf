variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type    = list
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list
  description = "AZs to use in your public and private subnet  (make sure they are consistent with your AWS region)"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "prefix_name" {}
