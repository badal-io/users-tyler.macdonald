resource "google_compute_instance_template" "webserver" {
  name_prefix = "${var.codename}-webserver-"
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
    network = var.network_name
    subnetwork = var.subnetwork_name
    dynamic "access_config" {
      for_each = var.external_ip ? [1] : []
      content {
        network_tier = "PREMIUM"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
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

  auto_healing_policies {
    health_check = google_compute_region_health_check.webserver.self_link
    initial_delay_sec = 60
  }
}

resource "google_compute_region_health_check" "webserver" {
  name = "${var.codename}-webserver"
  region = var.region
  timeout_sec = 5
  check_interval_sec = 5
  http_health_check {
    port = 80
  }
}

resource "google_compute_region_backend_service" "webserver" {
  name = "${var.codename}-webserver"
  health_checks = [google_compute_region_health_check.webserver.id]
  port_name = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  region = var.region
  backend {
    group = google_compute_instance_group_manager.webserver.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_url_map" "webserver" {
  name = "${var.codename}-webserver"
  default_service = google_compute_region_backend_service.webserver.id
  region = var.region
}

resource "google_compute_region_target_http_proxy" "webserver" {
  name = "${var.codename}-webserver"
  url_map = google_compute_region_url_map.webserver.id
  region = var.region
}

resource "google_compute_forwarding_rule" "webserver" {
  name = "${var.codename}-webserver"
  target = google_compute_region_target_http_proxy.webserver.id
  network = var.network_name
  region = var.region
  ip_protocol = "TCP"
  port_range = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  depends_on = [
    google_compute_region_backend_service.webserver
  ]
}
