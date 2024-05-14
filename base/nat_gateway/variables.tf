

variable "project_id" {
  type        = string
  description = "Project ID for Restricted Shared VPC."
}

variable "vpc_name" {
  type        = string
  description = "name of vpc"
}

variable "vpc_self_link" {
  type        = string
  description = "vpc network self link"
}

variable "subnetwork_self_link" {
  type        = string
  description = "subnetwork self link"
}

variable "region" {
  type        = string
  description = "region for cloud nat"
}

variable "nat_num_addresses" {
  type        = number
  description = "number of NAT external IP's to reserve"
}