variable "record_name" {
  description = "the name of the dns record to create"
  default     = "test"
}
variable "record_type" {
  description = "The dns record type to be used"
  default     = "A"
}
variable "record_ttl" {
  description = "defauly time to live for domain records"
  default     = 300
}

