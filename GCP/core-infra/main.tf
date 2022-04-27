terraform {
  required_providers{
      google = {
          source = "hashicorp/google",
          version = "~>3.88.0"
      }
  }
  required_version = ">= 0.12.0"
}

data "google_organization" "org" {
    organization = var.org_id  
}

resource "google_project" "demo_environment" {
  name = var.project_name
  project_id = var.project_id
  org_id = var.org_id
  billing_account = var.billing_account
}

resource "google_project_service" "project_api" {
  count                      = length(var.project_apis)
  project                    = var.project_id
  service                    = var.project_apis[count.index]
  disable_dependent_services = true
  depends_on                 = [google_project.demo_environment]  
}