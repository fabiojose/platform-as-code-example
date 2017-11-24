resource "kubernetes_service" "apigateway" {
  metadata {
    name = "apigateway"
    namespace = "${var.acronym}-${var.env}"

    labels {
      app = "apigateway",
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
      app     = "apigateway",
      version = "${var.app_version}"
    }
    session_affinity = "ClientIP"
    port {
      port = 8080
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
