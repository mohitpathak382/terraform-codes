resource "google_compute_instance" "this" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {}  # remove this if you only want private IP; include if you need public
  }

  # metadata_startup_script = var.metadata_startup_script

  tags    = var.tags
  labels  = var.labels
}
