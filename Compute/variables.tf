variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "subnetwork" {}

variable "image_family" {
  default = "rhel-9"
}
variable "image_project" {
  default = "rhel-cloud"
}

variable "frontend_config" {
  type = object({
    count             = number
    machine_type      = string
    startup_script    = string
    tags              = list(string)
    labels            = map(string)
  })
}
