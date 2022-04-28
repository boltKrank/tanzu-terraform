// ----------------------------------------------------------------------------
// Create and configure the Kubernetes cluster
//
// https://www.terraform.io/docs/providers/google/r/container_cluster.html
// ----------------------------------------------------------------------------
locals {
  cluster_oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.full_control",
    "https://www.googleapis.com/auth/service.management",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}
resource "google_container_cluster" "tap_cluster" {
  name                     = var.cluster_name
  description              = "tap cluster"
  location                 = var.cluster_location
  network                  = var.cluster_network
  subnetwork               = var.cluster_subnetwork
  enable_kubernetes_alpha  = var.enable_kubernetes_alpha
  enable_legacy_abac       = var.enable_legacy_abac
  enable_shielded_nodes    = var.enable_shielded_nodes
  remove_default_node_pool = true
  initial_node_count       = var.min_node_count
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }

  resource_labels = var.resource_labels

}

resource "google_container_node_pool" "primary" {
  name               = "${var.cluster_name}-primary"
  location           = var.cluster_location
  cluster            = google_container_cluster.tap_cluster.name
  initial_node_count = var.min_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    preemptible  = var.node_preemptible
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    disk_type    = var.node_disk_type

    oauth_scopes = local.cluster_oauth_scopes

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
