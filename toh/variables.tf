variable "backend_port" {}

variable "frontend_port" {}

variable "github" {}

variable "db_user" {}

variable "db_password" {
  sensitive   = true
}
