locals {
  cluster_map = {
    for env, env_cfg in var.deployment_matrix :
    for region, region_cfg in env_cfg.regions :
    "${env_cfg.project_id}-${region}" => {
      project_id                 = env_cfg.project_id
      region                     = region
      cluster_name               = "${var.cluster_config.name_prefix}-${region}"
      network                    = region_cfg.network
      subnetwork                 = region_cfg.subnetwork
      pod_range                  = region_cfg.pod_range
      service_range              = region_cfg.service_range
      master_ipv4_cidr_block     = region_cfg.master_ipv4_cidr_block
      master_authorized_networks = try(region_cfg.authorized_networks, [])
      service_account            = try(region_cfg.service_account, null)
    }
  }
}

# ==============================================
# GKE AUTOPILOT CLUSTER RESOURCE
# ==============================================

resource "google_container_cluster" "autopilot_clusters" {
  for_each = local.cluster_map

  name     = each.value.cluster_name
  location = each.value.region
  project  = each.value.project_id

  enable_autopilot    = true
  deletion_protection = var.cluster_config.deletion_protection

  release_channel {
    channel = var.cluster_config.release_channel
  }

  network    = each.value.network
  subnetwork = each.value.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = each.value.pod_range
    services_secondary_range_name = each.value.service_range
  }

  private_cluster_config {
    enable_private_nodes    = var.cluster_config.enable_private_nodes
    enable_private_endpoint = var.cluster_config.enable_private_endpoint
    master_ipv4_cidr_block  = each.value.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(each.value.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = each.value.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  workload_identity_config {
    workload_pool = var.cluster_config.enable_workload_identity ? "${each.value.project_id}.svc.id.goog" : null
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = each.value.service_account
      oauth_scopes    = var.cluster_config.oauth_scopes
    }
  }

  dynamic "binary_authorization" {
    for_each = var.cluster_config.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = var.cluster_config.binary_authorization_mode
    }
  }

  enable_shielded_nodes = var.cluster_config.enable_shielded_nodes
}
