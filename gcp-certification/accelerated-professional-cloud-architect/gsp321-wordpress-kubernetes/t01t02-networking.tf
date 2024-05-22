locals {
  network_topology = {
    "${var.codename}-dev-vpc" = {
      "${var.codename}-dev-wp" = "192.168.16.0/20"
      "${var.codename}-dev-mgmt" = "192.168.32.0/20"
    },
    "${var.codename}-prod-vpc" = {
      "${var.codename}-prod-wp" = "192.168.48.0/20"
      "${var.codename}-prod-mgmt" = "192.168.64.0/20"
    }
  }
}

resource "google_compute_network" "vpc" {
  for_each = local.network_topology
  name = each.key
  auto_create_subnetworks = false
  project = local.project
}

locals {
  subnets = flatten([
    for vpc_name, subnets in local.network_topology: [
      for subnet_name, cidr in subnets : {
        vpc_name = vpc_name
        subnet_name = subnet_name
        cidr = cidr
      }
    ]
  ])
}

resource "google_compute_subnetwork" "subnet" {
  for_each = { for subnet in local.subnets: subnet.subnet_name => subnet }
  name = each.key
  network = each.value.vpc_name
  region = var.region
  ip_cidr_range = each.value.cidr
  depends_on = [google_compute_network.vpc]
}

resource "google_compute_firewall" "console_ssh" {
  for_each = google_compute_network.vpc
  name = "gsp321-${each.key}-console-ssh"
  network = each.value.id
  description = "Allow console.cloud.google.com incoming SSH"
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

# peering path for google services when external ip is turned off
resource "google_compute_global_address" "internal" {
  for_each = google_compute_network.vpc

  name = "gsp321-${each.key}-internal"
  purpose = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network = each.value.name
}

resource "google_service_networking_connection" "internal" {
  for_each = google_compute_global_address.internal

  network = reverse(split("/", each.value.network))[0]
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [each.value.name]
  depends_on = [module.apis]
}

resource "google_compute_router" "router" {
  for_each = google_compute_network.vpc
  name = each.key
  network = each.value.id
}

resource "google_compute_router_nat" "nat" {
  for_each = google_compute_router.router
  name = each.key
  router = each.value.name
  region = each.value.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

