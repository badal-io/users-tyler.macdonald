# Task #4 - Create and configure Cloud SQL Instance
# The "configure" step is handled by the Bastion Host startup script in
# task 3.

resource "random_password" "database_root_password" {
  length = 16
  special = false
  upper = false
}

output "database_root_password" {
  description = "Root password for MySQL database"
  value = random_password.database_root_password.result
  sensitive = true
}

resource "google_sql_database_instance" "wordpress" {
  # provider = google-beta

  name = "${var.codename}-dev-db"
  region = var.region
  deletion_protection = false
  database_version = "MYSQL_8_0"
  root_password = random_password.database_root_password.result

  settings {
    tier = "db-f1-micro"
    dynamic "ip_configuration" {
      for_each = var.external_ip ? [1] : []
      content {
        ipv4_enabled = true
      }
    }
    dynamic "ip_configuration" {
      for_each = var.external_ip ? [] : [1]
      content {
        ipv4_enabled = false
        private_network = google_compute_network.vpc[
          "${var.codename}-dev-vpc"].id
        enable_private_path_for_google_cloud_services = true
      }
    }
  }

  depends_on = [
    google_service_networking_connection.internal,
    google_compute_global_address.internal
  ]
}

resource "google_sql_user" "wordpress_admin" {
  name = "root"
  password = ""
  host = "%"
  instance = google_sql_database_instance.wordpress.name
}
