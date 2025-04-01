terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.34.0"
    }
  }
}

provider "google-beta"{
  project = "aicc-proj-1"
  region  = "us-central1"
}

provider "google" {
  project = "aicc-proj-1"
  region  = "us-central1"
}
