resource "google_iam_workload_identity_pool" "gitlab-pool" {
  workload_identity_pool_id = "gitlab-pool"
  project                   = var.gcp_project_name
}

resource "google_iam_workload_identity_pool_provider" "gitlab-provider-jwt" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.gitlab-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gitlab-jwt"
  project                            = var.gcp_project_name
  attribute_condition                = "assertion.namespace_path.startsWith(\"${var.gitlab_namespace_path}\")"
  attribute_mapping = {
    "google.subject"           = "assertion.sub", # Required
    "attribute.aud"            = "assertion.aud",
    "attribute.project_path"   = "assertion.project_path",
    "attribute.project_id"     = "assertion.project_id",
    "attribute.namespace_id"   = "assertion.namespace_id",
    "attribute.namespace_path" = "assertion.namespace_path",
    "attribute.user_email"     = "assertion.user_email",
    "attribute.ref"            = "assertion.ref",
    "attribute.ref_type"       = "assertion.ref_type",
  }
  oidc {
    issuer_uri = var.gitlab_url
    allowed_audiences = [var.gitlab_url]
  }
}

resource "google_service_account" "gitlab" {
  account_id   = "gitlab-service-account"
  display_name = "Service Account for GitLab"
}

resource "google_service_account_iam_binding" "gitlab-runner-oidc" {
  service_account_id = google_service_account.gitlab.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab-pool.name}/attribute.project_id/${var.gitlab_project_id}"
  ]

}

output "GCP_WORKLOAD_IDENTITY_PROVIDER" {
  value = google_iam_workload_identity_pool_provider.gitlab-provider-jwt.name
}

output "GCP_SERVICE_ACCOUNT_EMAIL" {
  value = google_service_account.gitlab.email
}
