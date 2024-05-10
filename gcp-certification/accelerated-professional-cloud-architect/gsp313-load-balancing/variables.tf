variable "project" {
  description = "Google Cloud project to deploy to"
}

variable "region" {
  description = "region to deploy to"
}

variable "zone" {
  description = "zone to deploy to"
}

variable "codename" {
  description = "fanciful name for this deployment"
  default = "nucleus"
}

variable "small_instance_type" {
  description = "type of instance to use for small instances"
  default = "e2-micro"
}

variable "normal_instance_type" {
  description = "type of instance to use for workload instances"
  default = "e2-medium"
}

variable "jumphost_name" {
  description = "name of the jumphost"
}

variable "firewall_rule_name" {
  description = "name of firewall rule to add to default VPC"
}


