resource "google_dns_managed_zone" "amatsu-zone" {
  name        = "amatsu-zone"
  dns_name    = "amat.su."
  description = "Amat.su DNS"
}

resource "google_dns_record_set" "amatsu-prod" {
  name         = google_dns_managed_zone.amatsu-zone.dns_name
  managed_zone = google_dns_managed_zone.amatsu-zone.name
  type         = "A"
  ttl          = 180

  rrdatas = ["72.14.188.154"]
}

resource "google_dns_record_set" "amatsu-dev" {
  name         = "dev.${google_dns_managed_zone.amatsu-zone.dns_name}"
  managed_zone = google_dns_managed_zone.amatsu-zone.name
  type         = "A"
  ttl          = 180

  rrdatas = [google_compute_address.amatsu-prod.address]
}
