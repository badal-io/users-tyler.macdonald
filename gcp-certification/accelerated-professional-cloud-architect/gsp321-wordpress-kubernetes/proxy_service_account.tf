# service account that is "already created" in GSP321

resource "google_service_account" "proxy" {
  count = var.create_proxy_account ? 1 : 0
  account_id = var.proxy_account
  display_name = "Proxy account for GSP321"
  project = local.project
}

resource "google_project_iam_member" "database" {
  count = var.create_proxy_account ? 1 : 0
  project = local.project
  role = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.proxy[0].email}"
}
