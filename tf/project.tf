provider "google" {
  project = var.project_id
  region  = var.region

  version = "~> 3.0.0"
}

resource "google_project_service" "enabled-apis" {
  project = data.google_project.project.project_id

  # http://amat.su/Rb8gSP
  for_each = toset([
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  service            = each.key
  disable_on_destroy = false
}

