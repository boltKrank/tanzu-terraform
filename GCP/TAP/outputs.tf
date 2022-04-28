output "cluster_host" {
  description = "The host URL of the cluster"
  value       = "https://${module.cluster.cluster_endpoint}"
}

output "cluster_token" {
  description = "The access token for the Kubernetes cluster"
  value       = data.google_client_config.default.access_token
  sensitive   = true
}

output "cluster_ca_cert" {
  description = "The cluster ca certificate"
  value       = module.cluster.cluster_ca_certificate
  sensitive   = true
}

output "gcp_project" {
  description = "The GCP project in which the resources got created"
  value       = var.gcp_project
}

output "cluster_location" {
  description = "The location of the created Kubernetes cluster"
  value       = var.cluster_location
}

output "cluster_name" {
  description = "The name of the created Kubernetes cluster"
  value       = local.cluster_name
}

output "connect" {
  description = "The cluster connection string to use once Terraform apply finishes"
  value       = "gcloud container clusters get-credentials ${local.cluster_name} --zone ${var.cluster_location} --project ${var.gcp_project}"
}
