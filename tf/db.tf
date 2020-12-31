resource "google_sql_database" "database" {
  name     = "amatsu-db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "amatsu" {
  name    = "amatsu-db-instance"
  project = var.project_id
  region  = var.project_region

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}
