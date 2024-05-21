locals {
  wordpress_values = {
    db = {
      connection_name = google_sql_database_instance.wordpress.connection_name
      sql_user = var.wordpress_sql_user
      sql_password = var.wordpress_sql_password
    }
  }
}

resource "helm_release" "wordpress" {
  name = "wordpress"
  chart = "${path.module}/helm/jooli-wordpress"
  values = [ yamlencode(local.wordpress_values) ]
  depends_on = [google_container_cluster.gke]
}
