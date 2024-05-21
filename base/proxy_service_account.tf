# service account that is "already created" in GSP321

resource "google_service_account" "proxy" {
  account_id = "proxies"
  display_name = "Proxy account for GSP321"
}

resource "google_project_iam_member" "database" {
  project = var.project
  role = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.proxy.email}"
}
