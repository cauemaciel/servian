provider "google" {
  credentials = "/Users/cauemaciel/.config/gcloud/application_default_credentials.json"
  project     = "topgun-servian"
  region      = "us-east1"
}

terraform {
  required_version = ">= 1.1.0"

  required_providers {
    google = {
      version = "~> 4.0"
    }
    null = {
      version = "~> 2.1"
    }
  }

  backend "gcs" {
    bucket  = "terraform-state-servian-develop"
    prefix  = "/network/state"
    credentials = "/Users/cauemaciel/.config/gcloud/application_default_credentials.json"
    }
}
