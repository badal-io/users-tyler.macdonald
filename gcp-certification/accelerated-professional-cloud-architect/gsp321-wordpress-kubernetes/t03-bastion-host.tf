locals {
  bastion_subnets = flatten([
    for vpc_name, subnets in local.network_topology: [
      [
        for subnet_name, cidr in subnets: subnet_name
        if endswith(subnet_name, "-mgmt")
      ]
    ]
  ])
}

resource "google_compute_instance" "bastion" {
  zone = var.zone
  name = "${var.codename}-bastion"
  machine_type = var.instance_type
  boot_disk {
    auto_delete = true
  }

  dynamic "network_interface" {
    for_each = local.bastion_subnets
    content {
      subnetwork = network_interface.key
      dynamic "access_config" {
        for_each = var.external_ip ? [1] : []
        content {
          network_tier = "PREMIUM"
        }
      }
    }
  }
}
