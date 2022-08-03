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
