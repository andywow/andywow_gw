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
  default     = "your.zone.com."
  description = "DNS zone name"
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

variable "gitlab_nginx_ingress_ip" {
  default     = "127.0.0.1"
  description = "Gitlab ingress nginx ip"
}

# dev cluster settings
variable "dev_cluster_name" {
  default     = "dev-cluster"
  description = "Cluster name for DEV environment"
}

variable "dev_node_count" {
  default     = 1
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
