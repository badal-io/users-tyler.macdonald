module "main_nat_gateway" {
  source = "../contrib/nat_gateway"
  project_id = var.project
  vpc_name = var.vpc_name
  vpc_self_link = google_compute_network.vpc_network.self_link
  nat_num_addresses = 1
  region = var.region
  subnetwork_self_link = google_compute_subnetwork.region.self_link

  depends_on = [module.apis]
}
