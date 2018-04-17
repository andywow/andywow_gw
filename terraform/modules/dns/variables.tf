variable "name" {
  default = "default"
}

variable "dns_name" {
  default = "otus.final."
}

variable "description" {
  default = "default zone"
}

variable "ip_address" {
  default     = "127.0.0.1"
  description = "IP address to alias"
}

variable "dns_aliases" {
  type    = "list"
  default = []
}
