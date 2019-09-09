
output "reddit-docker-external-ip" {
  value = "${google_compute_instance.docker-monolith-instances.*.network_interface.0.access_config.0.nat_ip}"
}
