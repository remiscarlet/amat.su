resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-traffic"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["https-traffic"]
}

resource "google_compute_firewall" "allow-dev" {
  name    = "allow-dev"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8000", "8001", "8123"]
  }

  target_tags = ["dev-traffic"]
}
