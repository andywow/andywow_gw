# create GCE DNS zone
resource "google_dns_managed_zone" "default" {
  name        = "${var.name}"
  dns_name    = "${var.dns_name}"
  description = "${var.description}"
}

resource "google_dns_record_set" "default" {
  count = "${length(var.dns_aliases)}"
  name  = "${var.dns_aliases[count.index]}.${google_dns_managed_zone.default.dns_name}"
  type  = "A"
  ttl   = 0

  managed_zone = "${google_dns_managed_zone.default.name}"

  rrdatas = ["${var.ip_address}"]
}
