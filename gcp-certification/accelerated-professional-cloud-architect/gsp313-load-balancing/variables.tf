variable "project" {
  description = "Google Cloud project to deploy to"
  type = string
}

variable "network_name" {
  description = "Name of network to deploy resources to"
  default = "default"
  type = string
}

variable "subnetwork_name" {
  description = "Name of subnetwork to deploy resources to"
  default = null
  type = string
}

variable "region" {
  description = "region to deploy to"
  type = string
}

variable "zone" {
  description = "zone to deploy to"
  type = string
}

variable "codename" {
  description = "fanciful name for this deployment"
  default = "nucleus"
  type = string
}

variable "small_instance_type" {
  description = "type of instance to use for small instances"
  default = "e2-micro"
  type = string
}

variable "normal_instance_type" {
  description = "type of instance to use for workload instances"
  default = "e2-medium"
  type = string
}

variable "jumphost_name" {
  description = "name of the jumphost"
  type = string
}

variable "firewall_rule_name" {
  description = "name of firewall rule to add to default VPC"
  type = string
}

variable "external_ip" {
  description = "Whether to assign external IPs to resources"
  type = bool
  default = true
}

