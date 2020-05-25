variable "prefix_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
	type = list
}

variable "webserver_sg_id" {
  type        = list
  description = "security groupd id of the webserver" 
}

variable "storage_gb" {
	description = "how much storage space do you want to allocate?"
  	default     = 5
}

variable "mariadb_version" {
	default = "10.1.34"
}

variable "mariadb_instance_type" {
	description = "use micro if you want to use the free tier"
	default     = "db.t2.small"
}

variable "db_name" {
	description = "database name"
}

variable "db_username" {
	description = "database username"
	default     = "root"
}

variable "db_password" {
	description = "database user password"
}

variable "is_multi_az" {
	description = "set to true to have high availability"
	default = false
}

variable "storage_type" {
	description = "Storage type used for the database"
	default = "gp2"
}


variable "backup_retention_period" {
	description = "how long you’re going to keep your backups (30 max) ?"
	default     = 1
}

