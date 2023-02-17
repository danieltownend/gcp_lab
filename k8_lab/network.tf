# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# Reserve static internal address
resource "google_compute_global_address" "peering_address" {
  provider      = google-beta

  name          = "default-vpc-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  project       = var.project_id
  prefix_length = 16
  network       = google_compute_network.vpc.id

  depends_on = [
    google_project_service.servicenetworking
  ]
}

# Create connection via VPC peering
resource "google_service_networking_connection" "vpc_peering" {
  provider                = google-beta
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_address.name]

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.subnet,
    google_compute_global_address.peering_address,
    google_project_service.servicenetworking
  ]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering              = google_service_networking_connection.vpc_peering.peering
  network              = google_compute_network.vpc.name
  import_custom_routes = true
  export_custom_routes = true
}


# firewall
resource "google_compute_firewall" "rule" {
  name    = "myfirewall"
  network = google_compute_network.vpc.name
  source_tags = ["vpc"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

}