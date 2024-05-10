resource "google_compute_firewall_policy_rule" "http" {
  firewall_policy = "default"
  action = "allow"
  direction = "INGRESS"
  priority = 100
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports = [80]
    }
    src_ip_ranges = ["0.0.0.0/0"]
  }
}
