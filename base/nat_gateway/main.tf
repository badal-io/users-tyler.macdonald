/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_compute_router" "nat_router" {
  name    = "cr-${var.vpc_name}-${var.region}-nat-router"
  project = var.project_id
  region  = var.region
  network = var.vpc_self_link
}

resource "google_compute_address" "nat_external_addresses" {
  count   = var.nat_num_addresses
  project = var.project_id
  name    = "ca-${var.vpc_name}-${var.region}-nat-${count.index}"
  region  = var.region
}

resource "google_compute_router_nat" "compute_nat_router" {
  name                               = "rn-${var.vpc_name}-${var.region}-egress"
  project                            = var.project_id
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_external_addresses.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnetwork_self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    filter = "ALL"
    enable = true
  }
}