variable "vpc_name" {
  description = "Name of base VPC"
  default = "base"
}

variable "project" {
  description = "name of project"
  default = "prj-s-tmacdonald-sbx57-1992"
}

variable "region" {
  description = "default region to operate in"
  default = "northamerica-northeast2" # Toronto
}

variable "zone" {
  description = "default zone to operate in"
  default = "northamerica-northeast2-b"
}
