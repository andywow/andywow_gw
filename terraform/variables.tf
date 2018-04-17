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

# root dns zone
variable "dns_zone_root_name" {
  default     = "andywow.io."
  description = "DNS zone name"
}

# ci/cd dns zone
variable "dns_zone_cicd_name" {
  default     = "cicd.andywow.io."
  description = "CI/CD DNS zone name"
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
  default     = 50
  description = "Gitlab node disk size"
}

variable "gitlab_node_machine_type" {
  default     = "n1-standard-2"
  description = "Gitlab node machine type"
}

# dev dns zone
variable "dns_zone_dev_name" {
  default     = "dev.andywow.io."
  description = "dev DNS zone name"
}

# dev cluster settings
variable "dev_cluster_name" {
  default     = "dev-cluster"
  description = "Cluster name for DEV environment"
}

variable "dev_node_count" {
  default     = 2
  description = "dev node count"
}

variable "dev_node_disk_size" {
  default     = 20
  description = "dev node disk size"
}

variable "dev_node_machine_type" {
  default     = "g1-small"
  description = "dev node machine type"
}




