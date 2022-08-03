resource "google_project" "science_comp_poc" {
  name                = var.project_id
  project_id          = var.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# Terraform state bucket
resource "random_pet" "tfstate_bucket" {
}

resource "google_storage_bucket" "tfstate" {
  project  = google_project.science_comp_poc.project_id
  name     = random_pet.tfstate_bucket.id
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Enable APIs
resource "google_project_service" "serviceusage" {
  project            = google_project.science_comp_poc.project_id
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  project            = google_project.science_comp_poc.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbilling" {
  project            = google_project.science_comp_poc.project_id
  service            = "cloudbilling.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project            = google_project.science_comp_poc.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "servicenetworking" {
  project            = google_project.science_comp_poc.project_id
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  project            = google_project.science_comp_poc.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secretmanager" {
  project            = google_project.science_comp_poc.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry" {
  project            = google_project.science_comp_poc.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Build and assign roles to the Cloud Build Service Account
resource "google_project_service" "cloudbuild" {
  project            = google_project.science_comp_poc.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_organization_iam_member" "cloudbuild_sa_billing_user" {
  org_id = var.org_id
  role   = "roles/billing.user"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_project_creator" {
  org_id = var.org_id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_org_policy_policy_admin" {
  org_id = var.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_compute_admin" {
  org_id = var.org_id
  role   = "roles/compute.admin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_resource_manager_project_iam_admin" {
  org_id = var.org_id
  role   = "roles/resourcemanager.projectIamAdmin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_iam_service_account_admin" {
  org_id = var.org_id
  role   = "roles/iam.serviceAccountAdmin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_storage_admin" {
  org_id = var.org_id
  role   = "roles/storage.admin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "cloudbuild_sa_notebooks_admin" {
  org_id = var.org_id
  role   = "roles/notebooks.admin"
  member = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_organization_iam_member" "compute_sa_notebooks_viewer" {
  org_id = var.org_id
  role   = "roles/notebooks.viewer"
  member = "serviceAccount:${local.compute_sa_email}"
}

resource "google_project_iam_member" "cloudbuild_sa_service_usage_admin" {
  project = google_project.science_comp_poc.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_project_iam_member" "cloudbuild_sa_pubsub_editor" {
  project = google_project.science_comp_poc.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_project_iam_member" "cloudbuild_sa_cloud_functions_admin" {
  project = google_project.science_comp_poc.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_project_iam_member" "cloudbuild_sa_service_account_user" {
  project = google_project.science_comp_poc.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${local.cloudbuild_sa_email}"

  depends_on = [
    google_project_service.cloudbuild
  ]
}

# Cloud Build Triggers
resource "google_cloudbuild_trigger" "push_to_main" {
  project     = google_project.science_comp_poc.project_id
  name        = "${var.repo_name}-github-push-to-${var.branch_name}"
  description = "GitHub Repository Trigger ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  github {
    owner = var.repo_owner
    name  = var.repo_name
    push {
      branch = var.branch_name
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _ENV             = var.environment
    _TFSTATE_BUCKET  = google_storage_bucket.tfstate.name
    _BILLING_ACCOUNT = var.billing_account
    _ORG_ID          = var.org_id
    _FOLDER_ID       = var.folder_id
    _REGION          = var.region
    _REPO_OWNER      = var.repo_owner
    _REPO_NAME       = var.repo_name
    _BRANCH_NAME     = var.branch_name
  }

  depends_on = [
    google_project_service.cloudbuild,
  ]
}

resource "google_cloudbuild_trigger" "science_comp_launcher_push_to_main" {
  project     = google_project.science_comp_poc.project_id
  name        = "${var.science_comp_launcher_repo_name}-github-push-to-${var.science_comp_launcher_branch_name}"
  description = "GitHub Repository Trigger ${var.science_comp_launcher_repo_owner}/${var.science_comp_launcher_repo_name} (${var.science_comp_launcher_branch_name})"

  github {
    owner = var.science_comp_launcher_repo_owner
    name  = var.science_comp_launcher_repo_name
    push {
      branch = var.science_comp_launcher_branch_name
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION = var.region
  }

  depends_on = [
    google_project_service.cloudbuild,
  ]
}

resource "google_cloudbuild_trigger" "science_comp_notify_push_to_main" {
  project     = google_project.science_comp_poc.project_id
  name        = "${var.science_comp_notify_repo_name}-github-push-to-${var.science_comp_notify_branch_name}"
  description = "GitHub Repository Trigger ${var.science_comp_notify_repo_owner}/${var.science_comp_notify_repo_name} (${var.science_comp_notify_branch_name})"

  github {
    owner = var.science_comp_notify_repo_owner
    name  = var.science_comp_notify_repo_name
    push {
      branch = var.science_comp_notify_branch_name
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION                       = var.region
    _SENDGRID_API_KEY_SECRET_NAME = google_secret_manager_secret.sendgrid_api_key.name
    _SENDGRID_SENDER_EMAIL        = var.sendgrid_sender_email
  }

  depends_on = [
    google_project_service.cloudbuild,
  ]
}

# Firestore
# Only Owner can create App Engine applications https://cloud.google.com/appengine/docs/standard/python/roles#primitive_roles
resource "google_project_service" "appengine" {
  project            = google_project.science_comp_poc.project_id
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firestore" {
  project                    = google_project.science_comp_poc.project_id
  service                    = "firestore.googleapis.com"
  disable_dependent_services = true
}

resource "google_app_engine_application" "firestore" {
  provider      = google-beta
  project       = google_project.science_comp_poc.project_id
  location_id   = var.region
  database_type = "CLOUD_FIRESTORE"

  depends_on = [
    google_project_service.appengine
  ]
}

# Cloud Build Community Builders
resource "google_artifact_registry_repository" "hpc_toolkit" {
  project       = google_project.science_comp_poc.project_id
  location      = var.region
  repository_id = "hpc-toolkit"
  format        = "DOCKER"

  depends_on = [
    google_project_service.artifactregistry
  ]
}

resource "null_resource" "submit_community_builders" {
  provisioner "local-exec" {
    command     = "./submit-community-builders.sh ${google_project.science_comp_poc.project_id} ${var.region} ${google_artifact_registry_repository.hpc_toolkit.repository_id}"
    working_dir = "${path.module}/scripts"
  }

  depends_on = [
    google_project_service.cloudbuild,
  ]
}

# Sendgrid Secret
resource "google_secret_manager_secret" "sendgrid_api_key" {
  project   = google_project.science_comp_poc.project_id
  secret_id = "sendgrid-api-key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_version" "sendgrid_api_key" {
  secret      = google_secret_manager_secret.sendgrid_api_key.id
  secret_data = var.sendgrid_api_key

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_iam_member" "sendgrid_api_key_access" {
  project   = google_project.science_comp_poc.project_id
  secret_id = google_secret_manager_secret.sendgrid_api_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.compute_sa_email}"

  depends_on = [
    google_project_service.secretmanager
  ]
}
