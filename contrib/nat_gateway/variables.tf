variable "subnetwork_self_link" {
  type        = string
  description = "subnetwork self link"
}

variable "nat_num_addresses" {
  type        = number
  description = "number of NAT external IP's to reserve"
}
