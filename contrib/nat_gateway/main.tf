/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

data "google_compute_subnetwork" "network" {
  name = strcontains(var.subnetwork_self_link, ":") ? null : reverse(split("/", var.subnetwork_self_link))[0]
  self_link = strcontains(var.subnetwork_self_link, ":") ? var.subnetwork_self_link : null
}

locals {
  subnetwork = data.google_compute_subnetwork.network
  project = local.subnetwork.project
  region = local.subnetwork.region
  vpc = local.subnetwork.network
}

data "google_compute_network" "network" {
  name = reverse(split("/", local.vpc))[0]
  project = local.project
}

locals {
  vpc_name = data.google_compute_network.network.name
}

resource "google_compute_router" "nat_router" {
  name    = "cr-${local.vpc_name}-${local.region}-nat-router"
  project = local.project
  region  = local.region
  network = local.vpc
}

resource "google_compute_address" "nat_external_addresses" {
  count   = var.nat_num_addresses
  project = local.project
  name    = "ca-${local.vpc_name}-${local.region}-nat-${count.index}"
  region  = local.region
}

resource "google_compute_router_nat" "compute_nat_router" {
  name                               = "rn-${local.vpc_name}-${local.region}-egress"
  project                            = local.project
  router                             = google_compute_router.nat_router.name
  region                             = local.region
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
