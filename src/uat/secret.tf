resource "kubernetes_secret" "apigateway-rundeck" {
  metadata {
    name = "apigateway-rundeck"
    namespace = "${var.acronym}-${var.env}"

    labels {
      app     = "apigateway",
      version = "${var.app_version}"
    }

    annotations {
      iac.deploy-policy = "unique"

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

  data {
    password = "FAKE_PASS_joiaHR0cHM6Ly9zMm0tYXBpLWdvdmVybmFuY2F0"
  }

  type = "Opaque"
}
