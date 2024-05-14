resource "google_compute_firewall" "http" {
  name = var.firewall_rule_name
  network = var.network_name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
}
