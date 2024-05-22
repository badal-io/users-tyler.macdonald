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
  remove_default_node_pool = false
  initial_node_count = 2
  deletion_protection = false
  node_locations = [var.zone]
  node_config {
    preemptible = true
    machine_type = var.cluster_instance_type
    service_account = data.google_service_account.proxy.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = 50
    disk_type = "pd-standard"
  }

  depends_on = [module.apis]
}

resource "kubernetes_secret" "gke" {
  metadata {
    name = "cloudsql-instance-credentials"
    annotations = {
      "kubernetes.io/service-account.name" = (
        data.google_service_account.proxy.name)
    }
  }
  data = {
    "key.json" = base64decode(google_service_account_key.gke.private_key)
  }
  depends_on = [local_file.kubeconfig]
}

locals {  
  kubeconfig = templatefile("${path.module}/kubeconfig.yaml.tftpl", {
    server = google_container_cluster.gke.endpoint
    token = data.google_client_config.gke.access_token
    certificate = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  })
}

resource "local_file" "kubeconfig" {
  # hack to force `filename` to depend on the creation of the cluster
  # so that other stuff that uses this value considers it "unknown until
  # after apply"
  filename = split("!!", "${path.root}/kubeconfig.yaml!!${google_container_cluster.gke.master_version}")[0]
  content = local.kubeconfig
}
