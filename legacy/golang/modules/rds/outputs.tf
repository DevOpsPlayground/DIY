output "hostnames" {
  value = "${aws_db_instance.postgres.*.address}"
}
