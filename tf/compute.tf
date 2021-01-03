data "template_file" "docker-compose" {
  template = file("templates/docker-compose.yml.tpl")

  vars = {
    gcr_project       = var.project_id
    gcr_image         = var.amatsu_image_name
    gcr_secrets_image = var.amatsu_secrets_image_name
    gcr_tag           = var.amatsu_image_tag
  }
}

data "template_file" "amatsu-daemon" {
  template = file("templates/amatsu-daemon.tpl")

  vars = {
    gcr_project = var.project_id
    gcr_image   = var.amatsu_image_name
    gcr_tag     = var.amatsu_image_tag
  }
}

data "template_file" "cloud-init-prod" {
  template = file("templates/cloud-init.yml.tpl")

  vars = {
    docker_compose_content = data.template_file.docker-compose.rendered
    amatsu_daemon_content  = data.template_file.amatsu-daemon.rendered
  }
}

resource "google_compute_address" "amatsu-prod" {
  name = "amatsu-prod-ipv4-addr"
}

resource "google_compute_instance" "amatsu-prod" {
  name         = "amatsu-prod"
  machine_type = "f1-micro"
  zone         = var.project_zone

  allow_stopping_for_update = true

  tags = ["http-traffic", "https-traffic", "ssh-traffic"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable-81-12871-103-0"
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
    user-data = data.template_file.cloud-init-prod.rendered
    sshKeys   = "${var.gce_ssh_user}:${var.gce_ssh_user_pub}"
  }
}
