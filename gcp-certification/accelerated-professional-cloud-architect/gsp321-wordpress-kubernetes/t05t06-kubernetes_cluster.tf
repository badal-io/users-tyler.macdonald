data "google_service_account" "proxy" {
  account_id = var.proxy_account
}

resource "google_service_account_key" "gke" {
  service_account_id = data.google_service_account.proxy.name
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "google_container_cluster" "gke" {
  name = "${var.codename}-dev"
  location = var.region
  network = google_compute_network.vpc["${var.codename}-dev-vpc"].self_link
  subnetwork = google_compute_subnetwork.subnet[
    "${var.codename}-dev-wp"].self_link
  remove_default_node_pool = true
  initial_node_count = 1
  deletion_protection = false
}

resource "google_container_node_pool" "gke" {
  name = "${var.codename}-dev"
  location = var.region
  cluster = google_container_cluster.gke.name
  node_count = 2

  node_config {
    preemptible = true
    machine_type = var.cluster_instance_type
    service_account = data.google_service_account.proxy.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "kubernetes_secret" "gke" {
  metadata {
    name = "cloudsql-instance-credentials"
    annotations = {
      "kubernetes.io/service-account.name" = data.google_service_account.proxy.name
    }
  }
  data = {
    "credentals.json" = base64decode(google_service_account_key.gke.private_key)
  }
}

locals {
  kubeconfig_vars = {
    server = google_container_cluster.gke.endpoint
    token = data.google_client_config.gke.access_token
    certificate = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  }
}

resource "local_sensitive_file" "kubeconfig" {
  # hack to force `filename` to depend on the creation of the cluster
  # so that other stuff that uses this value considers it "unknown until
  # after apply"
  filename = split("!!", "${path.root}/kubeconfig.yamL!!${google_container_cluster.gke.master_version}")[0]
  content = templatefile(
    "${path.module}/kubeconfig.yaml.tftpl", local.kubeconfig_vars)
}
