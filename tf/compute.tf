resource "google_compute_address" "amatsu-prod" {
  name = "amatsu-prod-ipv4-addr"
}

resource "google_compute_instance" "amatsu-prod" {
  name         = "amatsu-prod"
  machine_type = "f1-micro"
  zone         = var.project_zone

  allow_stopping_for_update = true

  tags = ["http-traffic", "https-traffic", "dev-traffic"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable-81-12871-103-0"
      size  = "25"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.amatsu-prod.address
    }
  }

  service_account {
    email = google_service_account.amatsu-sa.email
    scopes = [
      "storage-ro",
      "cloud-platform",
    ]
  }

  metadata = {
    user-data = data.null_data_source.cloud-init-prod.outputs["cloud_init_contents"]
    sshKeys   = "${var.gce_ssh_user}:${var.gce_ssh_user_pub}"
  }
}
