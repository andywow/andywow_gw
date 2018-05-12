output "gitlab_address" {
  value       = "${google_compute_address.gitlab.address}"
  description = "gitlab ingress address"
}

output "dev_address" {
  value       = "${google_compute_address.dev.address}"
  description = "dev ingress address"
}

output "ops_address" {
  value       = "${google_compute_address.ops.address}"
  description = "ops ingress address"
}
