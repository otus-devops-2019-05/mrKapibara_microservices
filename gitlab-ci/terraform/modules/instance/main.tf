resource "google_compute_instance" "instances" {
  count        = "${var.instances_count}"
  name         = "${var.instance_name}-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  labels = {
    environment = "${var.environment}"
    group       = "${var.group}"
  }

  tags = "${var.instance_tags}"

  boot_disk = {
    initialize_params = {
      size  = "${var.size}"
      type  = "${var.type}"
      image = "${var.image}"
    }
  }

  network_interface = {
    network = "${var.network}"

    access_config = {
      network_tier = "STANDARD"
    }
  }

  connection {
    type        = "ssh"
    user        = "${var.ssh_user}"
    agent       = "false"
    private_key = "${file(var.private_key_path)}"
  }
}

resource "google_compute_firewall" "instance_firewall" {
  name    = "${var.firewall_name}"
  network = "${var.firewall_network}"

  allow = {
    protocol = "tcp"
    ports    = "${var.firewall_ports}"
  }

  target_tags = "${var.firewall_target_tags}"
}
