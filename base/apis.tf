module "apis" {
  source = "../modules/gcp_project_apis"
  services = [
    "compute.googleapis.com"
  ]
}
