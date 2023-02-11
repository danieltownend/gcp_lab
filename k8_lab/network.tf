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
  network       = "${var.project_id}-vpc"
}

# Create connection via VPC peering
resource "google_service_networking_connection" "vpc_peering" {
  provider                = google-beta
  network                 = "${var.project_id}-vpc"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_address.name]
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