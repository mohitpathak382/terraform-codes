locals {
  environment_region_combinations = flatten([
    for env_key, env_config in var.environments : [
      for region_key, region_config in var.regions : {
        combination_key = "${env_key}-${region_key}"
        env_key         = env_key
        region_key      = region_key
        environment = env_config
        region_info = region_config
        project_id   = env_config.project_id
        cluster_name = "${var.cluster_config.name_prefix}-${env_key}-${region_key}"
        network    = env_config.network_config.network
        subnetwork = region_config.network.subnetwork
        master_ipv4_cidr_block = region_config.network.master_ipv4_cidr_block
        pod_range              = region_config.network.secondary_ranges.pod_range
        service_range          = region_config.network.secondary_ranges.service_range
        cluster_config = merge(var.cluster_config, env_config.cluster_overrides)
        master_authorized_networks = concat(
          var.cluster_config.master_authorized_networks,
          env_config.additional_authorized_networks
        )

        service_account = coalesce(
          env_config.service_account,
          var.cluster_config.default_service_account
        )

        labels = merge(
          var.common_labels,
          env_config.labels,
          {
            environment  = env_key
            region       = region_key
            cluster_mode = "autopilot"
          }
        )
      }
    ]
  ])

  clusters_map      = { for combo in local.environment_region_combinations : combo.combination_key => combo }
  environments_list = keys(var.environments)
  regions_list      = keys(var.regions)
}

resource "google_container_cluster" "autopilot_gke_clusters" {
  for_each = local.clusters_map

  name     = each.value.cluster_name
  location = each.value.region_info.location
  project  = each.value.project_id

  enable_autopilot    = true
  deletion_protection = each.value.cluster_config.deletion_protection
  resource_labels     = each.value.labels

  release_channel {
    channel = each.value.cluster_config.release_channel
  }

  network    = each.value.network
  subnetwork = each.value.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = each.value.pod_range
    services_secondary_range_name = each.value.service_range
  }

  private_cluster_config {
    enable_private_nodes    = each.value.cluster_config.enable_private_nodes
    enable_private_endpoint = each.value.cluster_config.enable_private_endpoint
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
    workload_pool = each.value.cluster_config.enable_workload_identity ? 
      "${each.value.project_id}.svc.id.goog" : null
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = each.value.service_account
      oauth_scopes    = each.value.cluster_config.oauth_scopes
    }
  }

  dynamic "binary_authorization" {
    for_each = each.value.cluster_config.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = each.value.cluster_config.binary_authorization_mode
    }
  }

  enable_shielded_nodes = each.value.cluster_config.enable_shielded_nodes
}
