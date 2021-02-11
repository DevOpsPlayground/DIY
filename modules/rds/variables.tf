variable "db_count" {
  default = 1
}

variable "rds_password" {
  description = "Password for RDS database"
}

variable "rds_username" {
  description = "Database usertname"
  default     = "playground"
}

variable "rds_db_name" {
  description = "Name of initial DB"
}

variable "db_instance" {
  description = "DB instance size"
  default     = "db.t2.micro"
}

variable "subnet_ids" {
  description = "Subnet ids"
}

variable "security_group_ids" {
  description = "list of security groups"
}
variable "PlaygroundName" {
  description = "Stack name"
}

variable "db_engine" {
  description = "Engine of the db"
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Version of db engine"
  default     = "11.5"
}

variable "storage_type" {
  description = "DB storage type"
  default     = "gp2"
}

variable "allocated_storage" {
  description = "Amount of dedicated storage"
  default     = 20
}

variable "db_identifier" {

}