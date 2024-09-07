variable "gcp_project_id" {
  type        = string
  description = "The ID for your GCP project"
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "asia-northeast1"
}
