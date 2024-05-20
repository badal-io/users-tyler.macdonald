resource "kubernetes_manifest" "deployment_wordpress" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "wordpress"
      }
      "name" = "wordpress"
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "wordpress"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "wordpress"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "WORDPRESS_DB_HOST"
                  "value" = "127.0.0.1:3306"
                },
                {
                  "name" = "WORDPRESS_DB_USER"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key" = "username"
                      "name" = "database"
                    }
                  }
                },
                {
                  "name" = "WORDPRESS_DB_PASSWORD"
                  "valueFrom" = {
                    "secretKeyRef" = {
                      "key" = "password"
                      "name" = "database"
                    }
                  }
                },
              ]
              "image" = "wordpress"
              "name" = "wordpress"
              "ports" = [
                {
                  "containerPort" = 80
                  "name" = "wordpress"
                },
              ]
              "volumeMounts" = [
                {
                  "mountPath" = "/var/www/html"
                  "name" = "wordpress-persistent-storage"
                },
              ]
            },
            {
              "command" = [
                "/cloud_sql_proxy",
                "-instances=$${connection_name}=tcp:3306",
                "-credential_file=/secrets/cloudsql/key.json",
              ]
              "image" = "gcr.io/cloudsql-docker/gce-proxy:1.33.2"
              "name" = "cloudsql-proxy"
              "securityContext" = {
                "allowPrivilegeEscalation" = false
                "runAsUser" = 2
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/secrets/cloudsql"
                  "name" = "cloudsql-instance-credentials"
                  "readOnly" = true
                },
              ]
            },
          ]
          "volumes" = [
            {
              "name" = "wordpress-persistent-storage"
              "persistentVolumeClaim" = {
                "claimName" = "wordpress-volumeclaim"
              }
            },
            {
              "name" = "cloudsql-instance-credentials"
              "secret" = {
                "secretName" = "cloudsql-instance-credentials"
              }
            },
          ]
        }
      }
    }
  }
}
