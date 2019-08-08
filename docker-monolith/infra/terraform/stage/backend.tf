terraform {
  backend "gcs" {
    bucket = "docker-monolith-bckt"
    prefix = "infra/stage"
  }
}
