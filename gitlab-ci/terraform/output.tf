output "gitlab_ci_runners_ip" {
  value = "${module.gitlab_ci_runner.instances_ip}"
}

output "gitlab_ci_server_ip" {
  value = "${module.gitlab_ci_server.instances_ip}"
}
