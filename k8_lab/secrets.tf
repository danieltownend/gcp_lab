resource "google_secret_manager_secret" "wp_username" {
  secret_id = "wp_username"

  labels = {
    label = "wp_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
      replicas {
        location = var.replica_region
      }
    }
  }
}

resource "google_secret_manager_secret" "wp_password" {
  secret_id = "wp_password"

  labels = {
    label = "wp_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
      replicas {
        location = var.replica_region
      }
    }
  }
}