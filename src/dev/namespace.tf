resource "kubernetes_namespace" "oss-dev" {
  metadata {
    name = "oss-dev"
    
    labels {
      acronym = "oss"
      env     = "dev"
    }

    annotations {
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
}
