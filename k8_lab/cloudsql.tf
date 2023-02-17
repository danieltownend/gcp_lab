resource "google_sql_database_instance" "wordpress" {
  name             = "wp"
  database_version = "MYSQL_5_7"
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
        ipv4_enabled    = false
        private_network = google_compute_network.vpc.id
    }
  }
  depends_on = [
    google_service_networking_connection.vpc_peering
    ]
}

resource "google_sql_user" "admin_user" {
  name     = var.db_user
  instance = google_sql_database_instance.wordpress.name
  password = var.db_password
  project  = var.project_id
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.wordpress.name
  project  = var.project_id
}