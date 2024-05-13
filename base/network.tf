# base network to do most sandboxy things on

resource "google_compute_network" "vpc_network" {
  name = "base"
  auto_create_subnetworks = true
  routing_mode = "GLOBAL"
}
