variable "machine_type" {
  description = "Machine-type"
  default     = "f1-micro"
}

variable "zone" {
  description = "Zone name"
  default     = "europe-west1-c"
}

variable "disk_image" {
  description = "Disc image"
}

variable "ssh_user" {
  description = "User for ssh connection"
}

variable "private_key_path" {
  description = "Path to privat part"
}

variable "instances_count" {
  description = "Number of instances to create"
  default     = 1
}

variable public_key_path {
  description = "Path to .pub key file"
}

variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}
variable "environment" {
  description = "Host environment"
}
