provider "google" {
  region = var.region
  project = var.project
}

provider "google-beta" {
  region = var.region
  project = var.project
}

data "google_client_config" "gke" {}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}
