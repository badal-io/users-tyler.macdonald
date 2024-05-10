resource "google_compute_instance_template" "webserver" {
  name = "${var.codename}-webserver"
  description = "NGinx Server Pool"
  region = var.region

  machine_type = var.normal_instance_type

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete = true
    boot = true
  }

  metadata_startup_script = file("webserver-startup.sh")

  network_interface {
    network = "default"
  }
}

resource "google_compute_instance_group_manager" "webserver" {
  name = "${var.codename}-webserver"
  base_instance_name = "${var.codename}-webserver"
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.webserver.self_link
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }
}
