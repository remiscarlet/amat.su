data "null_data_source" "values" {
  inputs = {
    docker_compose_content = templatefile("templates/docker-compose.yml.tpl", {
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
    })
    amatsu_daemon_content = templatefile("templates/amatsu-daemon.tpl", {
      gcr_project  = var.project_id
      gcr_image    = var.amatsu_image_name
      gcr_prod_tag = var.amatsu_prod_image_tag
      gcr_dev_tag  = var.amatsu_dev_image_tag
    })
    configure_firewall_content = templatefile("templates/configure-firewall.tpl", {
    })
    watchtower_config_content = templatefile("templates/watchtower-config.json.tpl", {
      gcr_auth_string = base64encode("_json_key:${var.amatsu_compute_sa_json_key}")
    })
  }
}

data "null_data_source" "cloud-init-prod" {
  inputs = {
    cloud_init_contents = templatefile("templates/cloud-init.yml.tpl", {
      docker_compose_content     = data.null_data_source.values.outputs["docker_compose_content"]
      amatsu_daemon_content      = data.null_data_source.values.outputs["amatsu_daemon_content"]
      configure_firewall_content = data.null_data_source.values.outputs["configure_firewall_content"]
      watchtower_config_content  = data.null_data_source.values.outputs["watchtower_config_content"]
    })
  }
}
