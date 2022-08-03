variable "billing_account" {
  type        = string
  description = "The alphanumeric ID of the billing account this project belongs to."
}

variable "org_id" {
  type        = string
  description = "The numeric ID of the organization."
}

variable "folder_id" {
  type        = string
  description = "The numeric ID of the folder this project should be created under."
}

variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  type        = string
  description = "The default GCP region for the created resources."
}

variable "environment" {
  type        = string
  description = "The environment of the bootstrapped project."
}

variable "repo_owner" {
  type        = string
  description = "This Github repository owner."
}

variable "repo_name" {
  type        = string
  description = "This Github repository name."
}

variable "branch_name" {
  default     = "main"
  description = "This Github branch name."
}

variable "science_comp_launcher_repo_owner" {
  type        = string
  description = "Science Comp Launcher Cloud Function Github repository owner."
}

variable "science_comp_launcher_repo_name" {
  type        = string
  description = "Science Comp Launcher Cloud Function Github repository name."
}

variable "science_comp_launcher_branch_name" {
  default     = "main"
  description = "Science Comp Launcher Cloud Function Github repository branch name."
}

variable "science_comp_notify_repo_owner" {
  type        = string
  description = "Science Comp Notify Cloud Function Github repository owner."
}

variable "science_comp_notify_repo_name" {
  type        = string
  description = "Science Comp Notify Cloud Function Github repository name."
}

variable "science_comp_notify_branch_name" {
  default     = "main"
  description = "Science Comp Notify Cloud Function Github repository branch name."
}

variable "sendgrid_api_key" {
  type        = string
  description = "Sendgrid API key."
  sensitive   = true
}

variable "sendgrid_sender_email" {
  type        = string
  description = "Sendgrid Verified Sender Email."
}
