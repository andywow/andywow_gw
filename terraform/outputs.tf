output "gitlab_address" {
  value       = "${google_compute_address.gitlab.address}"
  description = "gitlab ingress address"
}

output "kibana_address" {
  value       = "${google_compute_address.ops.address}"
  description = "ops ingress address"
}
