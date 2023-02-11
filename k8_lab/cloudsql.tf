resource "google_sql_database_instance" "primary" {
  name             = "wp"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
        ipv4_enabled    = false
        private_network = "projects/${var.project_id}/global/networks/${var.project_id}-vpc"
    }
  }
  depends_on = [
    google_service_networking_connection.vpc_peering
    ]
}

resource "google_sql_user" "admin_user" {
  name     = var.db_user
  instance = google_sql_database_instance.primary.name
  password = var.db_password
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.primary.name
}