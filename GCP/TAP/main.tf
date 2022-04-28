// ----------------------------------------------------------------------------
// Enforce Terraform version
//
// Using pessimistic version locking for all versions
// ----------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0, < 2.0"
  required_providers {
    google = {
      version = ">= 3.46.0, < 4.0.0"
    }
    google-beta = {
      version = ">= 3.46.0, < 4.0.0"
    }
    random = {
      version = ">= 2.2.0"
    }
    local = {
      version = ">= 1.2.0"
    }
    null = {
      version = ">= 2.1.0"
    }
    template = {
      version = ">= 2.1.0"
    }
    kubernetes = {
      version = ">= 2.10.0"
    }
  }
}

// ----------------------------------------------------------------------------
// Configure providers
// ----------------------------------------------------------------------------
provider "google" {
  project = var.gcp_project
}

provider "google-beta" {
  project = var.gcp_project
}

data "google_client_config" "default" {
}

provider "kubernetes" {
  load_config_file = false

  host                   = "https://${module.cluster.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
}


locals {
  cluster_name = var.cluster_name
  # provide backwards compatibility with the deprecated zone variable
  location       = var.zone != "" ? var.zone : var.cluster_location
}

// ----------------------------------------------------------------------------
// Enable all required GCloud APIs
//
// https://www.terraform.io/docs/providers/google/r/google_project_service.html
// ----------------------------------------------------------------------------
resource "google_project_service" "cloudresourcemanager_api" {
  provider           = google
  project            = var.gcp_project
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_api" {
  provider           = google
  project            = var.gcp_project
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  provider           = google
  project            = var.gcp_project
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "containerregistry_api" {
  provider           = google
  project            = var.gcp_project
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "containeranalysis_api" {
  provider           = google
  project            = var.gcp_project
  service            = "containeranalysis.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "serviceusage_api" {
  provider           = google
  project            = var.gcp_project
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container_api" {
  provider           = google
  project            = var.gcp_project
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

// ----------------------------------------------------------------------------
// Create Kubernetes cluster
// ----------------------------------------------------------------------------
module "cluster" {
  source = "./modules/cluster"

  gcp_project        = var.gcp_project
  cluster_name       = local.cluster_name
  cluster_location   = local.location
  cluster_network    = var.cluster_network
  cluster_subnetwork = var.cluster_subnetwork
  force_destroy      = var.force_destroy

  node_machine_type = var.node_machine_type
  node_disk_size    = var.node_disk_size
  node_disk_type    = var.node_disk_type
  node_preemptible  = var.node_preemptible
  min_node_count    = var.min_node_count
  max_node_count    = var.max_node_count
  release_channel   = var.release_channel
  resource_labels   = var.resource_labels

}
