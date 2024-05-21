# base network to do most sandboxy things on

resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "region" {
  name = var.region
  ip_cidr_range = "10.128.0.0/26"
  region = var.region
  network = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "proxy" {
  provider = google-beta
  name          = "website-net-proxy"
  ip_cidr_range = "10.129.0.0/26"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  private_ip_google_access = var.external_ip ? null : true
}

resource "google_compute_firewall" "console_ssh" {
  name = "console-ssh"
  network = google_compute_network.vpc_network.id
  description = "Allow console.cloud.google.com incoming SSH"
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}
