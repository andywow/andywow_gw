# Global settings

variable "gke_min_version" {
  default     = "1.8.8-gke.0"
  description = "GKE minimum version"
}

variable "project" {
  description = "Project ID"
}

variable "region" {
  default     = "europe-west1"
  description = "Region"
}

variable "zone" {
  default     = "europe-west1-b"
  description = "Zone"
}

# Gitlab settings
variable "gitlab_cluster_name" {
  default     = "gitlab-cluster"
  description = "Cluster name for Gitlab"
}

variable "gitlab_node_count" {
  default     = 1
  description = "Gitlab node count"
}

variable "gitlab_node_disk_size" {
  default     = 20
  description = "Gitlab node disk size"
}

variable "gitlab_node_machine_type" {
  default     = "n1-standard-2"
  description = "Gitlab node machine type"
}


