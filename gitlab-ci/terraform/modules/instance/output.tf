output "instances_ip" {
  value = "${google_compute_instance.instances.*.network_interface.0.access_config.0.nat_ip}"
}
