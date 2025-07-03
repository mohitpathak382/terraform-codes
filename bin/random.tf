# ------------------------------
# variables.tf
# ------------------------------

variable "project_ids" {
  description = "List of GCP project IDs"
  type        = list(string)
}

variable "regions" {
  description = "List of regions where GKE clusters will be deployed"
  type        = list(string)
}

variable "project_network_map" {
  description = "Map of project_id to its VPC and subnet names"
  type = map(object({
    network    = string
    subnetwork = string
  }))
}

variable "common_config" {
  description = "Common GKE configuration"
  type = object({
    name_prefix                  = string
    release_channel              = string
    enable_autopilot             = bool
    enable_private_nodes         = bool
    enable_private_endpoint      = bool
    deletion_protection          = optional(bool)
    master_authorized_networks   = optional(list(object({
      cidr_block   = string
      display_name = string
    })))
    auto_provisioning_defaults = object({
      service_account = optional(string)
    })
  })
}

variable "ip_allocation_map" {
  description = "Map of project_id => region => IP config"
  type = map(map(object({
    pod_range              = string
    service_range          = string
    master_ipv4_cidr_block = string
  })))
}


# ------------------------------
# locals.tf
# ------------------------------

locals {
  gke_cluster_configs = flatten([
    for project_id in var.project_ids : [
      for region in var.regions : {
        project_id     = project_id
        region         = region
        name           = "${var.common_config.name_prefix}-${region}"
        network        = var.project_network_map[project_id].network
        subnetwork     = var.project_network_map[project_id].subnetwork
        release_channel = var.common_config.release_channel
        enable_autopilot = var.common_config.enable_autopilot
        enable_private_nodes = var.common_config.enable_private_nodes
        enable_private_endpoint = var.common_config.enable_private_endpoint
        deletion_protection = try(var.common_config.deletion_protection, false)
        master_authorized_networks = try(var.common_config.master_authorized_networks, [])
        pod_range              = var.ip_allocation_map[project_id][region].pod_range
        service_range          = var.ip_allocation_map[project_id][region].service_range
        master_ipv4_cidr_block = var.ip_allocation_map[project_id][region].master_ipv4_cidr_block
        auto_provisioning_defaults = var.common_config.auto_provisioning_defaults
      }
    ]
  ])
}


# ------------------------------
# main.tf
# ------------------------------

module "gke_clusters" {
  source = "./modules/gke"

  for_each = {
    for config in local.gke_cluster_configs : "${config.project_id}-${config.region}" => config
  }

  gke_config = {
    project_id                 = each.value.project_id
    region                     = each.value.region
    name                       = each.value.name
    network                    = each.value.network
    subnetwork                 = each.value.subnetwork
    release_channel            = each.value.release_channel
    enable_autopilot           = each.value.enable_autopilot
    enable_private_nodes       = each.value.enable_private_nodes
    enable_private_endpoint    = each.value.enable_private_endpoint
    deletion_protection        = each.value.deletion_protection
    master_authorized_networks = each.value.master_authorized_networks
    pod_range                  = each.value.pod_range
    service_range              = each.value.service_range
    master_ipv4_cidr_block     = each.value.master_ipv4_cidr_block
    auto_provisioning_defaults = each.value.auto_provisioning_defaults
  }
}


# ------------------------------
# modules/gke/variables.tf (child module)
# ------------------------------

variable "gke_config" {
  description = "Configuration for GKE private cluster"
  type = object({
    project_id                 = string
    region                     = string
    name                       = string
    network                    = string
    subnetwork                 = string
    release_channel            = string
    enable_autopilot           = bool
    enable_private_nodes       = bool
    enable_private_endpoint    = bool
    deletion_protection        = bool
    master_ipv4_cidr_block     = string
    pod_range                  = string
    service_range              = string
    master_authorized_networks = list(object({
      cidr_block   = string
      display_name = string
    }))
    auto_provisioning_defaults = object({
      service_account = optional(string)
    })
  })
}


# ------------------------------
# modules/gke/main.tf (child module)
# ------------------------------

resource "google_container_cluster" "autopilot_gke" {
  name     = var.gke_config.name
  location = var.gke_config.region
  project  = var.gke_config.project_id

  enable_autopilot    = var.gke_config.enable_autopilot
  deletion_protection = var.gke_config.deletion_protection

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
    enable_private_nodes    = var.gke_config.enable_private_nodes
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
      service_account = var.gke_config.auto_provisioning_defaults.service_account
    }
  }
}
