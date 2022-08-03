locals {
  cloudbuild_sa_email = "${google_project.science_comp_poc.number}@cloudbuild.gserviceaccount.com"
  compute_sa_email    = "${google_project.science_comp_poc.number}-compute@developer.gserviceaccount.com"
}
