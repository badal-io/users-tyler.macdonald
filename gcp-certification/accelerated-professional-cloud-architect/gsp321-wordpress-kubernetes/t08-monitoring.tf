data "kubernetes_resource" "wordpress_service" {
  api_version = "v1"
  kind = "Service"

  metadata {
    name = "wordpress"
    namespace = "default"
  }

  depends_on = [helm_release.wordpress, google_container_cluster.gke]
}

locals {
  service_ip = data.kubernetes_resource.wordpress_service.object.status.loadBalancer.ingress[0].ip
}

resource "google_monitoring_uptime_check_config" "wordpress" {
  display_name = "${var.codename}-wordpress"
  timeout = "60s"

  http_check {
    path = "/"
    port = 80
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project
      host = local.service_ip
    }
  }

  depends_on = [helm_release.wordpress]
}
