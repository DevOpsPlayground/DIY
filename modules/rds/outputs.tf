output "hostname" {
  value = aws_db_instance.postgres.address
}
# output "single_hostname" {
#   value = element(concat(aws_db_instance.postgres.*.address, list("")), 0)
# }