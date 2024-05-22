resource "google_project" "project" {
  count = var.create_project ? 1 : 0
  name = "GSP321"
  project_id = var.project
  billing_account = var.billing_account
  auto_create_network = var.auto_create_network
}

module "apis" {
  source = "../../../modules/gcp_project_apis"
  services = var.create_project ? [
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
  ] : [
    "servicenetworking.googleapis.com",
  ]
  depends_on = [google_project.project]
}

locals {
  project = (
    var.create_project ? google_project.project[0].project_id : var.project)
}
