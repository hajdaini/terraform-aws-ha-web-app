variable "region" {
  default = "us-west-2"
}

variable "prefix_name" {
  default = "devopssec"
}

variable "bucket_name" {
  default = "devopssec-bucket"
}

variable "db_password" {}

data "aws_ami" "ubuntu-ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200430"]
    }
    owners = ["099720109477"] # Canonical
}