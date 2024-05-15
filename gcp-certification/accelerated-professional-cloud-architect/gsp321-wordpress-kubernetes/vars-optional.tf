variable "codename" {
  description = "codename for this deployment"
  type = string
  default = "griffin"
}

variable "instance_type" {
  description = "default instance type to use"
  type = string
  default = "e2-medium"
}

variable "wordpress_sql_user" {
  description = "name of the wordpress user"
  type = string
  default = "wp_user"
}

variable "wordpress_sql_password" {
  description = "password for the wordpress user"
  type = string
  default = "stormwind_rules"
}

variable "kubernetes_config_url" {
  description = "where to fetch kubernetes config from"
  type = string
  default = "gs://cloud-training/gsp321/wp-k8s"
}
