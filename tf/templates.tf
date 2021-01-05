data "template_file" "configure-firewall" {
  template = file("templates/configure-firewall.tpl")
}

data "template_file" "docker-compose" {
  template = file("templates/docker-compose.yml.tpl")

  vars = {
    gcr_project  = var.project_id
    gcr_image    = var.amatsu_image_name
    gcr_prod_tag = var.amatsu_prod_image_tag
    gcr_dev_tag  = var.amatsu_dev_image_tag

    env_amatsu_prod_host   = var.amatsu_prod_host
    env_amatsu_prod_port   = var.amatsu_prod_port
    env_amatsu_dev_host    = var.amatsu_dev_host
    env_amatsu_dev_port    = var.amatsu_dev_port
    env_amatsu_admin_email = var.amatsu_admin_email
    env_acme_ca_uri        = var.acme_ca_uri
    env_gunicorn_user      = var.gunicorn_user
  }
}

data "template_file" "amatsu-daemon" {
  template = file("templates/amatsu-daemon.tpl")

  vars = {
    gcr_project  = var.project_id
    gcr_image    = var.amatsu_image_name
    gcr_prod_tag = var.amatsu_prod_image_tag
    gcr_dev_tag  = var.amatsu_dev_image_tag
  }
}

data "template_file" "watchtower_config" {
  template = file("templates/watchtower-config.json.tpl")

  vars = {
    gcr_auth_string = base64encode("_json_key:${var.amatsu_compute_sa_json_key}")
  }
}

data "template_file" "cloud-init-prod" {
  template = file("templates/cloud-init.yml.tpl")

  vars = {
    docker_compose_content     = data.template_file.docker-compose.rendered
    amatsu_daemon_content      = data.template_file.amatsu-daemon.rendered
    configure_firewall_content = data.template_file.configure-firewall.rendered
    watchtower_config_content  = data.template_file.watchtower_config.rendered
  }
}
