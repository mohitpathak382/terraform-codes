variable "name" {}
variable "zone" {}
variable "machine_type" {}
variable "image" {}
variable "subnetwork" {}
# variable "metadata_startup_script" {}
variable "tags" {
  type = list(string)
  default = []
}
variable "labels" {
  type = map(string)
  default = {}
}
