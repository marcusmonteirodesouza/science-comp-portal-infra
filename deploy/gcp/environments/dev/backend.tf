terraform {
  backend "gcs" {
    bucket = "" // This will be replaced during the Cloud Build
  }
}
