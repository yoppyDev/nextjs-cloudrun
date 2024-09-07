provider "google" {
  project                   = var.gcp_project_id
  region                    = var.region
}

module "artifact-registry" {
  source = "./modules/artifact-registry"

  location      = var.region
  repository_id = "nextjs-docker-repo"
  description   = "nextjs docker repository"
}

