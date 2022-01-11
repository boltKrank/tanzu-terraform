terraform {
  required_providers {
    google = {
      source  = "hashicorp/google",
      version = "~>3.88.0"
    }
  }
  required_version = ">= 0.12.0"
}

# Generic GCP stuff
module "core-infra" {
  source          = "./modules/core-infra"
  org_id          = var.org_id
  project_name    = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
}

