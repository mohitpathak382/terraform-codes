resource "google_compute_network" "vpc" {
  name                    = var.vpc_config.network_name
  project                 = var.vpc_config.project_id
  auto_create_subnetworks = lookup(var.vpc_config, "auto_create_subnetworks", false)
  description             = lookup(var.vpc_config, "description", null)
}

resource "google_compute_subnetwork" "subnet" {
  for_each = {
    for subnet in var.vpc_config.subnets : subnet.subnet_name => subnet
  }

  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  network                  = google_compute_network.vpc.id
  project                  = var.vpc_config.project_id
  private_ip_google_access = each.value.subnet_private_access

  dynamic "secondary_ip_range" {
    for_each = lookup(var.vpc_config.secondary_ranges, each.value.subnet_name, [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_firewall" "rules" {
  for_each = {
    for rule in lookup(var.vpc_config, "firewall_rules", []) :
    rule.name => rule
  }

  name          = each.value.name
  description   = each.value.description
  direction     = each.value.direction
  priority      = each.value.priority
  project       = var.vpc_config.project_id
  network       = google_compute_network.vpc.id
  source_ranges = each.value.ranges

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}

resource "google_compute_route" "routes" {
  for_each = {
    for route in lookup(var.vpc_config, "routes", []) :
    route.name => route
  }

  name            = each.value.name
  dest_range      = each.value.dest
  network         = google_compute_network.vpc.name
  project         = var.vpc_config.project_id

  next_hop_ip       = lookup(each.value, "next_hop_ip", null)
  next_hop_instance = lookup(each.value, "next_hop_instance", null)
}

