# Google provider settings
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "gitlab-cluster" {
  source             = "./modules/gke"
  zone               = "${var.zone}"
  gke_min_version    = "${var.gke_min_version}"
  initial_node_count = "${var.gitlab_node_count}"
  cluster_name       = "${var.gitlab_cluster_name}"
  node_machine_type  = "${var.gitlab_node_machine_type}"
  node_disk_size     = "${var.gitlab_node_disk_size}"
}

