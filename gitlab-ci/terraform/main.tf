provider "google" {}

module "vpc" {
  source          = "modules/vpc"
  public_key_path = "${var.public_key_path}"
  ssh_user        = "${var.ssh_user}"
}

module "gitlab_ci_server" {
  source               = "modules/instance"
  zone                 = "${var.zone}"
  instance_name        = "${var.gitlab_ci_server_instance_name}"
  instance_tags        = "${var.gitlab_ci_server_instance_tags}"
  machine_type         = "${var.gitlab_ci_server_machine_type}"
  image                = "${var.gitlab_ci_server_image}"
  ssh_user             = "${var.ssh_user}"
  private_key_path     = "${var.private_key_path}"
  group                = "${var.gitlab_ci_server_group}"
  size                 = "${var.gitlab_ci_server_disk_size}"
  firewall_name        = "${var.gitlab_ci_server_firewall_name }"
  firewall_ports       = "${var.gitlab_ci_server_firewall_ports}"
  firewall_target_tags = "${var.gitlab_ci_server_firewall_target_tags}"
}

module "gitlab_ci_runner" {
  source               = "modules/instance"
  zone                 = "${var.zone}"
  instance_name        = "${var.gitlab_ci_runner_instance_name}"
  instance_tags        = "${var.gitlab_ci_runner_instance_tags}"
  machine_type         = "${var.gitlab_ci_runner_machine_type}"
  image                = "${var.gitlab_ci_runner_image}"
  ssh_user             = "${var.ssh_user}"
  private_key_path     = "${var.private_key_path}"
  group                = "${var.gitlab_ci_runner_group}"
  size                 = "${var.gitlab_ci_runner_disk_size}"
  firewall_name        = "${var.gitlab_ci_runner_firewall_name }"
  firewall_ports       = "${var.gitlab_ci_runner_firewall_ports}"
  firewall_target_tags = "${var.gitlab_ci_runner_firewall_target_tags}"
}
