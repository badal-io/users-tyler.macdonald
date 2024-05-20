locals {
  wordpress_vars = {
    connection_name = google_sql_database_instance.wordpress.connection_name
    wordpress_sql_user = var.wordpress_sql_user
    wordpress_sql_password = var.wordpress_sql_password
  }

  wordpress_files = [
    "wp-env.yaml.tftpl",
    "wp-deployment.yaml.tftpl",
    "wp-service.yaml",
  ]

  wordpress_templates = {
    for file in local.wordpress_files: file => templatefile(
      "${path.module}/wp-k8s/${file}", local.wordpress_vars)
  }
}

resource "local_sensitive_file" "wordpress_manifest" {
  for_each = local.wordpress_templates
  filename = "${path.root}/wp-k8s.out/${each.key}"
  content = each.value

  provisioner "local-exec" {
    command = "kubectl apply -f \"${self.filename}\""
    environment = {
      "KUBECONFIG" = local_sensitive_file.kubeconfig.filename
      "TF_MANIFEST" = self.filename
    }
  }
}
