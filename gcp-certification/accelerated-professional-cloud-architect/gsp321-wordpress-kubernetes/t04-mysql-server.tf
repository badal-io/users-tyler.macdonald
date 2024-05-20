# Task #4 - Create and configure Cloud SQL Instance
# The "configure" step is handled by the Bastion Host startup script in
# task 3.

resource "random_password" "database_root_password" {
  length = 16
  special = true
}


output "database_root_password" {
  description = "Root password for MySQL database"
  value = random_password.database_root_password.result
  sensitive = true
}

resource "google_sql_database_instance" "wordpress" {
  name = "${var.codename}-dev-db"
  region = var.region
  deletion_protection = false
  database_version = "MYSQL_8_0"
  root_password = random_password.database_root_password.result

  settings {
    tier = "db-f1-micro"
  }
}
