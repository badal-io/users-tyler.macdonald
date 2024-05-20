# service account that is "already created" in GSP321

resource "google_service_account" "proxy" {
  account_id = "proxies"
  display_name = "Proxy account for GSP321"
}
