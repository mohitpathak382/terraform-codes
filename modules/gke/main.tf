# Creates a GKE (Google Kubernetes Engine) cluster with support for Autopilot, private nodes,
# IP aliasing, Binary Authorization, and Workload Identity integration.

resource "google_container_cluster" "pvt-cluster" {
  project    = var.gke_config.project_id     # GCP project where the cluster will be deployed
  location   = var.gke_config.region         # GCP region for the cluster
  name       = var.gke_config.name           # Name of the GKE cluster

  # VPC configuration
  network    = var.gke_config.network        # VPC network to host the cluster
  subnetwork = var.gke_config.subnetwork     # Subnetwork for cluster nodes and IP aliasing

  # Set the GKE release channel (e.g., RAPID, REGULAR, STABLE) to control feature rollout cadence
  release_channel {
    channel = var.gke_config.release_channel
  }

  # Enable Autopilot mode for fully managed clusters where GCP provisions and manages the nodes.
  enable_autopilot = var.gke_config.enable_autopilot

  # Private cluster configuration: keeps nodes and control plane isolated from the public internet
  private_cluster_config {
    enable_private_nodes    = var.gke_config.enable_private_nodes    # Nodes get only internal IPs
    enable_private_endpoint = var.gke_config.enable_private_endpoint # Control plane only accessible internally
    master_ipv4_cidr_block  = var.gke_config.master_ipv4_cidr_block  # CIDR block for control plane access
  }

  # Assign pre-created secondary IP ranges from the subnetwork for pods and services.
  # These enable VPC-native networking and avoid IP conflicts.
  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_config.pod_range     # Secondary range for Pods
    services_secondary_range_name = var.gke_config.service_range # Secondary range for Services
  }

  # Enable Workload Identity: maps Kubernetes service accounts to IAM identities,
  # providing fine-grained, secure access to GCP resources.
  workload_identity_config {
    workload_pool = "${var.gke_config.project_id}.svc.id.goog"
  }

  # Enable Binary Authorization if requested.
  # This ensures only signed and trusted container images are deployed to the cluster.
  dynamic "binary_authorization" {
    for_each = var.gke_config.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = var.gke_config.binary_authorization_mode
    }
  }

  # Prevent the cluster from being accidentally deleted.
  deletion_protection = var.gke_config.deletion_protection

  # Cluster autoscaling setup. GKE will automatically create/manage node pools
  # using the specified service account if provided (or default if not).
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = var.gke_config.service_account
    }
  }
}
