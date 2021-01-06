resource "google_sql_database" "database" {
  name     = "amatsu-db"
  instance = google_sql_database_instance.amatsu.name
}

resource "google_sql_database_instance" "amatsu" {
  name    = "amatsu-db-instance"
  project = var.project_id
  region  = var.project_region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "Amatsu"
        value = google_compute_address.amatsu-prod.address
      }
      authorized_networks {
        name  = "Remi Dev"
        value = var.remi_dev_vm_ip
      }
    }
  }

  deletion_protection = "true"
}

resource "google_sql_user" "amatsu-admin" {
  name     = var.db_master_user
  password = var.db_master_pass
  instance = google_sql_database_instance.amatsu.name
}
