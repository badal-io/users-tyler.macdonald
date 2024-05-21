module "main_nat_gateway" {
  for_each = var.external_ip ? {} : {cluster = google_container_cluster.gke}
  source = "../../../contrib/nat_gateway"
  nat_num_addresses = 1
  subnetwork_self_link = each.value.subnetwork

  depends_on = [module.apis]
}
