variable "count" {
  default = 2
}

variable "rds_password" {
  description = "Password for RDS database"
  default     = "kfdkflkflkrtpplwepldspdfl"
}

variable "rds_username" {
  description = "Database usertname"
  default     = "playground"
}

variable "rds_db_name" {
  description = "Name of initial DB"
  default     = "gosucks"
}

variable "db_instance" {
  description = "DB instance size"
  default     = "db.t2.micro"
}

variable "subnet_ids" {
  description = "Subnet ids"
  default     = ["subnet-0cb929b94e9a0374c", "subnet-066bf1b1ae0e1fd30"]
}

variable "security_group_ids" {
  description = "list of security groups"
  default     = ["sg-0dfdd42b779c822fb"]
}

variable "instance_name" {
  description = "database instance name, user friendly hostname"
  default     = "playground"
}

variable "name" {
  description = "Stack name"
  default     = "playground"
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