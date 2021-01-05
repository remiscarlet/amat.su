variable "project_id" {}
variable "project_name" {}
variable "project_region" {}
variable "project_zone" {}

variable "amatsu_master_sa_json_key" {}
variable "amatsu_compute_sa_json_key" {}
variable "db_master_user" {}
variable "db_master_pass" {}

variable "amatsu_image_name" {}
variable "amatsu_prod_host" {}
variable "amatsu_prod_image_tag" {}
variable "amatsu_prod_port" {}
variable "amatsu_dev_host" {}
variable "amatsu_dev_image_tag" {}
variable "amatsu_dev_port" {}
variable "amatsu_admin_email" {}
variable "acme_ca_uri" {}
variable "gunicorn_user" {}

variable "gce_ssh_user" {}
variable "gce_ssh_user_pub" {}

variable "remi_dev_vm_ip" {}
