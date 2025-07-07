locals {
  sql_instance_configs = flatten([
    for project_id, project_cfg in var.sql_project_configs : [
      for region, region_cfg in project_cfg.regions : [
        for db_version in region_cfg.database_versions : {
          instance_key        = "${project_id}-${region}-${db_version}"
          project_id          = project_id
          region              = region
          database_version    = db_version
          instance_name       = "sql-${region}-${lower(replace(db_version, "_", "-"))}"
          private_network     = "projects/${project_id}/global/networks/${project_cfg.network_name}"
          authorized_networks = try(region_cfg.authorized_networks, [])
        }
      ]
    ]
  ])
}
