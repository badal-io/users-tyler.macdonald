locals {
  bastion_subnets = flatten([
    for vpc_name, subnets in local.network_topology: [
      [
        for subnet_name, cidr in subnets: subnet_name
        if endswith(subnet_name, "-mgmt")
      ]
    ]
  ])

  startup_vars = {
    wordpress_sql_user = var.wordpress_sql_user
    wordpress_sql_password = var.wordpress_sql_password
    db_root_password = random_password.database_root_password.result
  }
}

resource "google_compute_instance" "bastion" {
  zone = var.zone
  name = "${var.codename}-bastion"
  machine_type = var.instance_type
  metadata_startup_script = templatefile(
    "${path.module}/bastion_startup.sh.tftpl", local.startup_vars)

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-11"
      size = 20
    }
  }

  dynamic "network_interface" {
    for_each = local.bastion_subnets
    content {
      subnetwork = network_interface.value
      dynamic "access_config" {
        for_each = var.external_ip ? [1] : []
        content {
          network_tier = "PREMIUM"
        }
      }
    }
  }

  depends_on = [google_sql_database_instance.wordpress, google_compute_subnetwork.subnet]
}
