variable "name" {
  default = "default"
}

variable "dns_name" {
  default = "otus.final."
}

variable "description" {
  default = "default zone"
}

variable "dns_aliases" {
  type    = "map"
  default = {}
}
