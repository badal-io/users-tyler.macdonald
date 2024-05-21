variable "services" {
  description = "list of services to enable"
  type = list(string)
}

variable "project" {
  description = "project to enable services in"
  type = string
  default = null
}

resource "google_project_service" "services" {
  for_each = toset(var.services)
  project = var.project
  service = each.value
}
