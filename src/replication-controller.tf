resource "kubernetes_replication_controller" "apigateway" {
  metadata {
    name      = "apigateway",
    namespace = "${var.acronym}-${var.env}"

    labels {
      app     = "apigateway",
      version = "${var.app_version}"
    }

    annotations {
      iac.deploy-policy = "bluegreen"

      iac.scm-commit  = "${var.iac_scm_commit}"
      iac.scm-branch  = "${var.iac_scm_branch}"
      iac.build-by    = "${var.iac_build_by}"
      iac.build-name  = "${var.iac_build_name}"
      iac.build-id    = "${var.iac_build_id}"
      iac.build-date  = "${var.iac_build_date}"
      iac.deploy-by   = "${var.iac_deploy_by}"
      iac.deploy-name = "${var.iac_deploy_name}"
      iac.deploy-id   = "${var.iac_deploy_id}"
      iac.deploy-date = "${var.iac_deploy_date}"
      iac.provider    = "${var.iac_provider}"
      iac.artifact    = "${var.iac_artifact}"
      iac.version     = "${var.iac_version}"
      project         = "${var.project}"
    }
  }

  spec {
    selector {
      app     = "apigateway"
      version = "${var.app_version}"
    }

    template {
      container {
        name  = "apigateway"
        image = "localhost:8086/oss-apigateway-app-nodejs6:latest"
        image_pull_policy = "IfNotPresent"

        env = [
          {
            name  = "PROJECT"
            value = "${var.acronym}-${var.env}"
          },

          {
            name  = "ENV"
            value = "${var.env}"
          },

          {
            name  = "PORT"
            value = "3000"
          },

          {
            name  = "API_DEF"
            value = "/etc/app/apidef/api-def.json"
          },

          {
            name  = "APP"
            value = "apigateway"
          },

          {
            name = "RUNDECK_TOKEN"
            value_from {
              secret_key_ref {
                name = "${kubernetes_secret.apigateway-rundeck.metadata.0.name}"
                key  = "password"
              }
            }
          },

          {
            name = "RUNDECK_URL"
            value_from {
              config_map_key_ref {
                name = "${kubernetes_config_map.apigateway.metadata.0.name}"
                key  = "RUNDECK_URL"
              }
            }
          }
        ]

        port {
          container_port = 3000
        }

        resources{
          limits{
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests{
            cpu    = "250m"
            memory = "128Mi"
          }
        }
        volume_mount = [
          {
            name       = "apigateway-volume-1"
            mount_path = "/etc/app/apidef"
          }
        ]
      }
    }
  }
}
