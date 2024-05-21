# service account that is "already created" in GSP321

resource "google_service_account" "proxy" {
  count = var.proxy_account == null ? 0 : 1
  account_id = var.proxy_account
  display_name = "Proxy account for GSP321"
}

resource "google_project_iam_member" "database" {
  count = var.proxy_account == null ? 0 : 1
  project = var.project
  role = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.proxy[0].email}"
}
