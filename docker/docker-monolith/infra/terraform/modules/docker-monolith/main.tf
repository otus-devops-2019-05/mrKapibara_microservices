resource "google_compute_instance" "docker-monolith-instances" {
  count        = "${var.instances_count}"
  name         = "docker-monolith-${count.index + 1}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["docker-monolith"]

  labels = {
    environment = "${var.environment}"
    group = "docker_monolith_instances"
  }

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {}
  }

  connection {
    type        = "ssh"
    user        = "${var.ssh_user}"
    agent       = "false"
    private_key = "${file(var.private_key_path)}"
  }
}

resource "google_compute_firewall" "docker-monolith-firewall" {
  name    = "docker-monolith-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-monolith"]
}
