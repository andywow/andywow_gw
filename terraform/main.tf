# Google provider settings
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_address" "gitlab" {
  name = "gitlab-ingress-address"
  region = "${var.gitlab_region}"
}

resource "google_compute_address" "dev" {
  name   = "dev-ingress-address"
  region = "${var.dev_region}"
}

resource "google_compute_address" "ops" {
  name   = "ops-ingress-address"
  region = "${var.ops_region}"
}

# gitlab cluster
module "gitlab_cluster" {
  source             = "./modules/gke"
  zone               = "${var.gitlab_zone}"
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

# dev cluster
module "dev_cluster" {
  source             = "./modules/gke"
  zone               = "${var.dev_zone}"
  gke_min_version    = "${var.gke_min_version}"
  initial_node_count = "${var.dev_node_count}"
  cluster_name       = "${var.dev_cluster_name}"
  node_machine_type  = "${var.dev_node_machine_type}"
  node_disk_size     = "${var.dev_node_disk_size}"

  labels = {
    "env"        = "dev"
    "node_group" = "search_engine"
  }
}

# ops cluster
module "ops_cluster" {
  source             = "./modules/gke"
  zone               = "${var.ops_zone}"
  gke_min_version    = "${var.gke_min_version}"
  initial_node_count = "${var.ops_node_count}"
  cluster_name       = "${var.ops_cluster_name}"
  node_machine_type  = "${var.ops_node_machine_type}"
  node_disk_size     = "${var.ops_node_disk_size}"

  labels = {
    "node_group" = "ops"
  }
}

# root dns zone
module "root_dns_zone" {
  source   = "./modules/dns"
  name     = "root-zone"
  dns_name = "${var.dns_zone_root_name}"

  dns_aliases = {
    "kubernetes-cicd" = "${module.gitlab_cluster.endpoint_ip}"
    "*.cicd"          = "${google_compute_address.gitlab.address}"
    "kubernetes-dev"  = "${module.dev_cluster.endpoint_ip}"
    "*.dev"          = "${google_compute_address.dev.address}"
    "kubernetes-ops"  = "${module.ops_cluster.endpoint_ip}"
    "kibana"          = "${google_compute_address.ops.address}"
    "elasticsearch"   = "${google_compute_address.ops.address}"
    "prometheus"      = "${google_compute_address.ops.address}"
    "alertmanager"    = "${google_compute_address.ops.address}"
    "grafana"         = "${google_compute_address.ops.address}"
  }
}
