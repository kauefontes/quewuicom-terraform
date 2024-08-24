provider "google" {
  project = "queuwuicom"
  region  = "us-central1"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }

  required_version = ">= 0.12"
}

resource "google_cloud_run_service" "default" {
  name     = "quewuicom"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "quewui/quewuicom:latest"
        ports {
          container_port = 8080
        }
        env {
          name  = "SERVER_HOST"
          value = "0.0.0.0"
        }
        env {
          name  = "SERVER_PORT"
          value = "8080"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "default" {
  service    = google_cloud_run_service.default.name
  location   = google_cloud_run_service.default.location
  role       = "roles/run.invoker"
  member     = "allUsers"
}
