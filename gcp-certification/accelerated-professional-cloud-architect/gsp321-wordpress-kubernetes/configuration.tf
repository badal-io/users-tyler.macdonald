provider "google" {
  region = var.region
  project = var.project
}

data "google_client_config" "gke" {}

provider "kubernetes" {
  # hack to force `config_path` to depend on the creation of the cluster
  config_path = split("!!", "${local_sensitive_file.kubeconfig.filename}!!${google_container_cluster.gke.master_version}")[0]
}
