module "apis" {
  source = "../../../modules/gcp_project_apis"
  services = [
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}
