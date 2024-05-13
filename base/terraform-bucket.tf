resource "google_storage_bucket" "terraform" {
  name = "badal-tmacdonald-terraform"
  location = var.region
  public_access_prevention = "enforced"
  uniform_bucket_level_access = "true"
}
