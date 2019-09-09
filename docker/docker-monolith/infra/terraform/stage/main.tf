provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "vpc" {
  source          = "../modules/vpc"
  ssh_user        = "${var.ssh_user}"
  public_key_path = "${var.public_key_path}"
}

module "docker-monolith" {
  source           = "../modules/docker-monolith"
  private_key_path = "${var.private_key_path}"
  zone             = "${var.zone}"
  disk_image       = "${var.disk_image}"
  ssh_user         = "${var.ssh_user}"
  instances_count  = "${var.instances_count}"
  machine_type     = "${var.machine_type}"
  environment     = "${var.environment}"
}
