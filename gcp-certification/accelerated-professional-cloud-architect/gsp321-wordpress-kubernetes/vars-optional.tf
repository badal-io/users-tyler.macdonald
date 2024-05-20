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

variable "external_ip" {
  description = "should compute instances have an external ip?"
  type = bool
  default = true
}

variable "cluster_instance_type" {
  description = "which instance type to use for GKE nodes"
  type = string
  default = "e2-standard-4"
}

# required because in terraform, service accounts must by 6+ letters long
variable "proxy_account" {
  description = "name of the proxy account"
  type = string
  default = "proxies"
}
