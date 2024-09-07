terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.0.0"
    }
  }

  cloud {
    organization = "YP"

    workspaces {
      name = "nextjs-cloudrun"
    }
  }

  required_version = "1.9.4"
}
