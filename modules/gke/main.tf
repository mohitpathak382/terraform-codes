resource "google_container_cluster" "pvt-cluster" {
  project  = var.gke_config.project_id
  location = var.gke_config.region
  name     = var.gke_config.name
  network    = var.gke_config.network
  subnetwork = var.gke_config.subnetwork
  release_channel {
    channel = var.gke_config.release_channel
  }
  enable_autopilot = var.gke_config.enable_autopilot
  private_cluster_config {
    enable_private_nodes    = var.gke_config.enable_private_nodes
    enable_private_endpoint = var.gke_config.enable_private_endpoint
    master_ipv4_cidr_block  = var.gke_config.master_ipv4_cidr_block
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_config.pod_range
    services_secondary_range_name = var.gke_config.service_range
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.gke_config.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }
  workload_identity_config {
    workload_pool = "${var.gke_config.project_id}.svc.id.goog"
  }

  dynamic "binary_authorization" {
    for_each = var.gke_config.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = var.gke_config.binary_authorization_mode
    }
  }

  deletion_protection = var.gke_config.deletion_protection
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = var.gke_config.service_account
    }
  }
}