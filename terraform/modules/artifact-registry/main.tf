resource "google_project_service" "artifact_registry_api" {
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}


resource "google_artifact_registry_repository" "docker-repo" {
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry_api]
}
