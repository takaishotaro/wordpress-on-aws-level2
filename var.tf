variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "env_code" {
  type = string
}

variable "rds_password" {}

variable "db_username" {}

variable "db_name" {}

variable "rds_endpoint" {}

variable "wp_username" {}

variable "wp_email" {}

variable "wp_password" {}
