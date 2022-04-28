output "cluster_name" {
  value = google_container_cluster.tap_cluster.name
}

output "cluster_location" {
  value = google_container_cluster.tap_cluster.location
}

output "cluster_endpoint" {
  value = google_container_cluster.tap_cluster.endpoint
}

output "cluster_client_certificate" {
  value = length(google_container_cluster.tap_cluster.master_auth) > 0 ? google_container_cluster.tap_cluster.master_auth[0].client_certificate : ""
}

output "client_client_key" {
  value = length(google_container_cluster.tap_cluster.master_auth) > 0 ? google_container_cluster.tap_cluster.master_auth[0].client_key : ""
}

output "cluster_ca_certificate" {
  value = length(google_container_cluster.tap_cluster.master_auth) > 0 ? google_container_cluster.tap_cluster.master_auth[0].cluster_ca_certificate : ""
}
