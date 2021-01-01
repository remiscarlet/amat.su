# resource "google_service_account" "amatsukaze" {} - Made manually through UI to set up app.terraform.io SA.


resource "google_service_account" "gcr_uploader" {
  account_id   = "amatsu-gcr-uploader"
  display_name = "Amatsu GCR Uploader"
}

resource "google_service_account" "amatsu-sa" {
  account_id   = "amatsu-sa"
  display_name = "Amatsu Compute SA"
}

resource "google_storage_bucket_iam_binding" "gcr-docker-image-access" {
  bucket = "artifacts.${var.project_id}.appspot.com"
  role   = "roles/storage.legacyBucketWriter"

  members = [
    "serviceAccount:${google_service_account.gcr_uploader.email}"
  ]
}

resource "google_storage_bucket_iam_binding" "gcr-docker-image-reader" {
  bucket = "artifacts.${var.project_id}.appspot.com"
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:${google_service_account.amatsu-sa.email}"
  ]
}
