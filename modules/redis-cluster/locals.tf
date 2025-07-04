locals {
  psc_configs = [for network in var.network.psc_networks : { network = network }]

  security_config = merge({
    transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_SERVER_AUTHENTICATION"
  }, var.security)

  automated_backup_enabled = try(var.backup.automated != null && var.backup.automated != {}, false)
  maintenance_enabled      = try(var.maintenance.weekly_windows != null && var.maintenance.weekly_windows != [], false)
}
