variable "instance_count" {
  description = "number of instances to create records for"
}
variable "instance_ips" {
  description = "List of IP's of the instances being used  the DNS hosted zone "
}
variable "record_name" {
  description = "the name of the dns record to create"
}
variable "record_type" {
  description = "The dns record type to be used"
  default     = "A"
}
variable "record_ttl" {
  description = "defauly time to live for domain records"
  default     = 300
}
