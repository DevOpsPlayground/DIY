resource "random_password" "password" {
  length  = 16
  special = true
}
resource "random_password" "remote_host" {
  length  = 16
  special = true
}
