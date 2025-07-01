resource "google_container_cluster" "autopilot_gke" {
  name     = var.gke_config.name
  location = var.gke_config.region
  project  = var.gke_config.project_id

  enable_autopilot = true
  deletion_protection = false
 
  release_channel {
    channel = var.gke_config.release_channel
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_config.pod_range
    services_secondary_range_name = var.gke_config.service_range
  }

  network    = var.gke_config.network
  subnetwork = var.gke_config.subnetwork

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.gke_config.enable_private_endpoint
    master_ipv4_cidr_block  = var.gke_config.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.gke_config.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.gke_config.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = "${var.gke_config.project_id}.svc.id.goog"
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = var.gke_config.service_account
    }
  }
}
