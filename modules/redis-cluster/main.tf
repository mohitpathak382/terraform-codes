resource "google_redis_cluster" "cluster" {
  name          = var.cluster.name
  project       = var.cluster.project_id
  shard_count   = var.cluster.shard_count
  replica_count = var.cluster.replica_count
  region  = var.cluster.region  
  node_type     = var.cluster.node_type

  dynamic "psc_configs" {
    for_each = local.psc_configs
    content {
      network = psc_configs.value.network
    }
  }

  transit_encryption_mode = local.security_config.transit_encryption_mode

  zone_distribution_config {
    mode = "SINGLE_ZONE"
    zone = "${var.cluster.region}-a"
  }

  dynamic "automated_backup_config" {
    for_each = local.automated_backup_enabled ? [1] : []
    content {
      retention = var.backup.automated.retention_days
      fixed_frequency_schedule {
        start_time {
          hours = var.backup.automated.start_hour
        }
      }
    }
  }

  dynamic "maintenance_policy" {
    for_each = local.maintenance_enabled ? [1] : []
    content {
      dynamic "weekly_maintenance_window" {
        for_each = var.maintenance.weekly_windows
        content {
          day = weekly_maintenance_window.value.day
          start_time {
            hours = weekly_maintenance_window.value.start_hour
          }
        }
      }
    }
  }
}