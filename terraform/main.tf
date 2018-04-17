# Google provider settings
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

# root dns zone
module "root_dns_zone" {
  source   = "./modules/dns"
  name     = "root-zone"
  dns_name = "${var.dns_zone_root_name}"
}

# gitlab cluster
module "gitlab_cluster" {
  source             = "./modules/gke"
  zone               = "${var.zone}"
  gke_min_version    = "${var.gke_min_version}"
  initial_node_count = "${var.gitlab_node_count}"
  cluster_name       = "${var.gitlab_cluster_name}"
  node_machine_type  = "${var.gitlab_node_machine_type}"
  node_disk_size     = "${var.gitlab_node_disk_size}"

  labels = {
    "helm_chart" = "gitlab"
    "node_group" = "cicd"
  }
}

# gitlab dns records
module "cicd_dns_zone" {
  source      = "./modules/dns"
  name        = "cicd-zone"
  dns_name    = "${var.dns_zone_cicd_name}"
  ip_address  = "${module.gitlab_cluster.endpoint_ip}"
  dns_aliases = ["kubernetes"]
}
