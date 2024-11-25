# Terraform for Google OpenID Connect Authentication

This Terraform project creates a Google Cloud Service Account and a Workload Identity Pool with a Workload Identity Provider to authenticate to Google Cloud with OpenID Connect.

These can be used in your CI/CD pipeline to authenticate to Google Cloud with OpenID Connect using the gcloud SDK.

This project creates the following resources:
- Google Cloud Service Account
- Workload Identity Pool
- Workload Identity Provider
- Google IAM Policy binding

It outputs the needed variables to authenticate to Google Cloud using the gcloud SDK.

# Requirements

1. Create the Workload Identity Pool, Workload Identity Provider and Google Cloud Service Account using this Terraform Project.

Creating the Workload Identity Pool and Workload Identity Provider defines the authentication into Google Cloud. At this point, you can authenticate from GitLab CI/CD job into Google Cloud. However, you have no permissions on Google Cloud (authorization).
To grant your GitLab CI/CD job permissions on Google Cloud, you must:
 
2. Grant IAM permissions to your service account on Google Cloud resources. These permissions vary significantly based on your use case. In general, grant this service account the permissions on your Google Cloud project and resources you want your GitLab CI/CD job to be able to use. This also includes permissions for the Terraform Remote backend.

## Terraform variables

- `gcp_project_name` - GCP project name
- `gitlab_namespace_path` - GitLab namespace path. This can be your username and additional path, e.g. `USERNAME/REPOSITORY_NAME`
- `gitlab_project_id` - GitLab project ID - This can be found in your GitLab project settings under 'General' > 'Naming, description, topics'
