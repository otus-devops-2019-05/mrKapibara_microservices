#instance variables
variable "instances_count" {
  description = "Count run instances"
  default     = "1"
}

variable "instance_name" {
  description = "instances name"
}

variable "zone" {
  description = "Zone"
}

variable "machine_type" {
  description = "machine_type"
  default     = "f1-micro"
}

variable "instance_tags" {
  type        = "list"
  description = "instance tags"
}

variable "ssh_user" {
  description = "User for ssh connection"
}

variable private_key_path {
  description = "Path to privat part"
}

variable "environment" {
  description = "env"
  default     = "dev"
}

variable "group" {
  description = "labels.group name"
  default     = "ungrouped"
}

variable "size" {
  description = "Disk size"
  default     = "10"
}

variable "type" {
  description = "Disk type"
  default     = "pd-ssd"
}

variable "image" {
  description = "Image family name"
  default     = "ubuntu-1604-lts"
}

variable "network" {
  description = "Network name"
  default     = "default"
}

# firewall section

variable "firewall_name" {
  description = "firewall rule name"
}

variable "firewall_network" {
  description = "firewall network"
  default     = "default"
}

variable "firewall_ports" {
  type        = "list"
  description = "Firewall ports"
}

variable "firewall_target_tags" {
  type        = "list"
  description = "firewall tags"
}
