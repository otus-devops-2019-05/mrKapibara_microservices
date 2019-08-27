variable "zone" {
  description = "Zone"
}

variable "ssh_user" {
  description = "User for ssh connection"
}

variable public_key_path {
  description = "Path to .pub key file"
}

variable private_key_path {
  description = "Path to privat part"
}

variable "environment" {
  description = "env"
  default     = "stage"
}

variable "gitlab_ci_server_group" {
  description = "labels.group name"
}

variable "gitlab_ci_server_disk_size" {
  description = "Disk size for gitlab ci server"
}

variable "gitlab_ci_server_instance_name" {
  description = "instance name"
}

variable "gitlab_ci_server_instance_tags" {
  type        = "list"
  description = "Tags lists for instances"
}

variable "gitlab_ci_server_machine_type" {
  description = "Ci server machine type"
}

variable "gitlab_ci_server_image" {
  description = "Image name"
}

variable "gitlab_ci_server_firewall_name" {
  description = " CI server firewall rule name"
}

variable "gitlab_ci_server_firewall_ports" {
  type        = "list"
  description = "CI server firewall ports"
}

variable "gitlab_ci_server_firewall_target_tags" {
  type        = "list"
  description = "CI server firewall target tags"
}

variable "gitlab_ci_runner_group" {
  description = "labels.group name"
}

variable "gitlab_ci_runner_disk_size" {
  description = "Disk size for gitlab ci runner"
}

variable "gitlab_ci_runner_instance_name" {
  description = "instance name"
}

variable "gitlab_ci_runner_instance_tags" {
  type        = "list"
  description = "Tags lists for instances"
}

variable "gitlab_ci_runner_machine_type" {
  description = "Ci runner machine type"
}

variable "gitlab_ci_runner_image" {
  description = "Image name"
}

variable "gitlab_ci_runner_firewall_name" {
  description = " CI runner firewall rule name"
}

variable "gitlab_ci_runner_firewall_ports" {
  type        = "list"
  description = "CI runner firewall ports"
}

variable "gitlab_ci_runner_firewall_target_tags" {
  type        = "list"
  description = "CI runner firewall target tags"
}
