module "main_nat_gateway" {
  source = "../contrib/nat_gateway"
  nat_num_addresses = 1
  subnetwork_self_link = google_compute_subnetwork.region.self_link

  depends_on = [module.apis]
}
