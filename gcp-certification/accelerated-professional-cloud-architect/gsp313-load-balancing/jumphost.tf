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
    network = "default"
    access_config {
      network_tier = "PREMIUM"
    }
  }

}
