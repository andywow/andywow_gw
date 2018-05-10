output "gitlab_address" {
  value       = "${google_compute_address.gitlab.address}"
  description = "gitlab ingress address"
}
