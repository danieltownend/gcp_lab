
# GKE cluster
resource "google_container_cluster" "primary" {
  name               = "${var.project_id}-gke"
  location           = var.zone
  initial_node_count = 1
  
  remove_default_node_pool = true
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
    
  }
  
}