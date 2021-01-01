resource "google_artifact_registry_repository" "amatsu" {
  provider = google-beta

  location      = var.project_region
  repository_id = "amatsu-images"
  description   = "Amat.su Images"
  format        = "DOCKER"
}


