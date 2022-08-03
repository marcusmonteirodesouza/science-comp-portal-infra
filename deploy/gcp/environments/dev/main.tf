data "google_project" "project" {
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Enable APIs
resource "google_project_service" "cloudfunctions" {
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudrun" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "eventarc" {
  service            = "eventarc.googleapis.com"
  disable_on_destroy = false
}

# GCS bucket for the Cloud Build artifacts
resource "random_pet" "cloudbuild_artifacts_bucket" {
}

resource "google_storage_bucket" "cloudbuild_artifacts" {
  name     = random_pet.cloudbuild_artifacts_bucket.id
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# alpha_fold
resource "google_pubsub_topic" "launch_rad_lab_alpha_fold" {
  name = "launch-rad-lab-alpha-fold"
}

resource "google_cloudbuild_trigger" "launch_rad_lab_alpha_fold_pub_sub" {
  project     = var.project_id
  name        = "launch-rad-lab-alpha-fold-pub-sub"
  description = "Launch RAD Lab Alpha Fold Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_rad_lab_alpha_fold.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.rad-lab.alpha-fold.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
  }
}

# data_science
resource "google_pubsub_topic" "launch_rad_lab_data_science" {
  name = "launch-rad-lab-data-science"
}

resource "google_cloudbuild_trigger" "launch_rad_lab_data_science_pub_sub" {
  project     = var.project_id
  name        = "launch-rad-lab-data-science-pub-sub"
  description = "Launch RAD Lab Data Science Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_rad_lab_data_science.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.rad-lab.data-science.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
  }
}

# genomics_cromwell
resource "google_pubsub_topic" "launch_rad_lab_genomics_cromwell" {
  name = "launch-rad-lab-genomics-cromwell"
}

resource "google_cloudbuild_trigger" "launch_rad_lab_genomics_cromwell_pub_sub" {
  project     = var.project_id
  name        = "launch-rad-lab-genomics-cromwell-pub-sub"
  description = "Launch RAD Lab Genomics Cromwell Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_rad_lab_genomics_cromwell.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.rad-lab.genomics-cromwell.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
  }
}

# genomics_dsub
resource "google_pubsub_topic" "launch_rad_lab_genomics_dsub" {
  name = "launch-rad-lab-genomics-dsub"
}

resource "google_cloudbuild_trigger" "launch_rad_lab_genomics_dsub_pub_sub" {
  project     = var.project_id
  name        = "launch-rad-lab-genomics-dsub-pub-sub"
  description = "Launch RAD Lab Genomics DSub Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_rad_lab_genomics_dsub.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.rad-lab.genomics-dsub.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
  }
}

# genomics_dsub
resource "google_pubsub_topic" "launch_rad_lab_silicon_design" {
  name = "launch-rad-lab-silicon-design"
}

resource "google_cloudbuild_trigger" "launch_rad_lab_silicon_design_pub_sub" {
  project     = var.project_id
  name        = "launch-rad-lab-silicon-design-pub-sub"
  description = "Launch RAD Lab Silicon Design Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_rad_lab_silicon_design.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.rad-lab.silicon-design.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
  }
}

# hpc-cluster-small
resource "google_pubsub_topic" "launch_hpc_toolkit_hpc_cluster_small" {
  name = "launch-hpc-toolkit-hpc-cluster-small"
}

resource "google_cloudbuild_trigger" "launch_hpc_toolkit_hpc_cluster_small_pub_sub" {
  project     = var.project_id
  name        = "launch-hpc-toolkit-hpc-cluster-small-pub-sub"
  description = "Launch HPC Toolkit HPC Cluster Small Trigger Pub/Sub ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.launch_hpc_toolkit_hpc_cluster_small.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.hpc-toolkit.hpc-cluster-small.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _REQUEST_ID      = local.request_id_substitution
    _STORAGE_BUCKET  = google_storage_bucket.cloudbuild_artifacts.name
    _BILLING_ACCOUNT = var.billing_account
    _ORGANIZATION_ID = var.org_id
    _FOLDER_ID       = var.folder_id
    _REGION          = var.region
  }
}

# RAD Lab Launcher Cloud Function

# RAD Lab Notify Cloud Function
# See https://cloud.google.com/build/docs/subscribe-build-notifications#receiving_build_notifications
resource "google_pubsub_topic" "cloud_builds" {
  name = "cloud-builds"
}

# See https://cloud.google.com/functions/docs/2nd-gen/getting-started#prerequisites
resource "google_project_iam_member" "pubsub_sa_sa_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
