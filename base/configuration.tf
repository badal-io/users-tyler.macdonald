provider "google" {
  region = var.region
  project = var.project
  add_terraform_attribution_label = true

  default_labels = {
    "badal-github-repo" = "users-tyler_macdonald"
    "badal-github-repo_path" = "base"
  }
}
