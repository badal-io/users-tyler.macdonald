variable "project" {
  description = "name of project"
}

variable "external_ip" {
  description = "do we have external ip access"
  default = true
}

variable "vpc_name" {
  description = "Name of base VPC"
  default = "base"
}

variable "region" {
  description = "default region to operate in"
  default = "northamerica-northeast2" # Toronto
}

variable "zone" {
  description = "default zone to operate in"
  default = "northamerica-northeast2-b"
}

variable "bucket_name" {
  description = "configuration bucket name"
  default = "badal-tmacdonald-terraform"
}
