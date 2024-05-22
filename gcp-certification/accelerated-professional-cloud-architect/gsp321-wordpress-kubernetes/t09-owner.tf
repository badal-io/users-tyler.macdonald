resource "google_project_iam_member" "owners" {
  for_each = var.owners
  project = local.project
  role = "roles/owner"
  member = "user:${each.value}"
}
