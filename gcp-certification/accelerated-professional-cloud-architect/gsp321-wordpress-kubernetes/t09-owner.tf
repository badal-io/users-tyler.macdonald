resource "google_project_iam_member" "owners" {
  for_each = var.owners
  project = var.project
  role = "roles/owner"
  member = "user:${each.value}"
}
