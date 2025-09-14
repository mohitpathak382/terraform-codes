provider "google" {
  project = var.project_id
  region  = var.region
}

# data "google_compute_image" "rhel" {
#   family  = var.image_family
#   project = var.image_project
# }

module "frontend" {
  source     = "../modules/compute_instance"
  count      = var.frontend_config.count
  name       = "doris-fe-${count.index}"
  zone       = var.zone
  machine_type = var.frontend_config.machine_type
  image      = "projects/debian-cloud/global/images/debian-12-bookworm-v20250910"
  subnetwork = var.subnetwork
  # metadata_startup_script = file(var.frontend_config.startup_script)
  tags       = var.frontend_config.tags
  labels     = var.frontend_config.labels
}

# module "backend" {
#   source     = "../modules/compute_instance"
#   count      = var.backend_config.count
#   name       = "doris-be-${count.index}"
#   zone       = var.zone
#   machine_type = var.backend_config.machine_type
#   image      = data.google_compute_image.rhel.self_link
#   subnetwork = var.subnetwork
#   metadata_startup_script = file(var.backend_config.startup_script)
#   tags       = var.backend_config.tags
#   labels     = var.backend_config.labels
# }
