resource "google_compute_instance" "jumphost" {
  name = var.jumphost_name
  machine_type = var.small_instance_type
  zone = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name
    dynamic "access_config" {
      for_each = var.external_ip ? [1] : []
      content {
        network_tier = "PREMIUM"
      }
    }
  }
}
