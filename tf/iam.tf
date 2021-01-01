# resource "google_service_account" "amatsukaze" {} - Made manually through UI to set up app.terraform.io SA.


resource "google_service_account" "gcr_uploader" {
  account_id   = "amatsu-gcr-uploader"
  display_name = "Amatsu GCR Uploader"
}

#resource "google_artifact_registry_repository_iam_member" "test-iam" {
#  provider = google-beta
#
#  location   = google_artifact_registry_repository.amatsu.location
#  repository = google_artifact_registry_repository.amatsu.name
#  role       = "roles/artifactregistry.writer"
#  member     = "serviceAccount:${google_service_account.gcr_uploader.email}"
#}

resource "google_container_registry" "amatsu-images" {
  project = var.project_id
}

resource "google_storage_bucket_iam_binding" "gcr-docker-image-access" {
  bucket = "artifacts.${var.project_id}.appspot.com"
  role   = "roles/storage.objectCreator"

  members = [
    "serviceAccount:${google_service_account.yc-infra-bot.email}"
  ]
}
