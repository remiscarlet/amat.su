provider "google" {
  project     = var.project_id
  region      = var.project_region
  credentials = var.amatsu_master_sa_json_key
}

provider "google-beta" {
  project     = var.project_id
  region      = var.project_region
  credentials = var.amatsu_master_sa_json_key
}

resource "google_project_service" "enabled-apis" {
  project = data.google_project.project.project_id

  # http://amat.su/Rb8gSP
  for_each = toset([
    "dns.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  service            = each.key
  disable_on_destroy = false
}

