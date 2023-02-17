variable "gke_username" {
  default     = "pie"
  description = "gke username"
}

variable "gke_password" {
  default     = "pie"
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "project_id" {
  description = "project id"
}

variable "zone" {
  description = "zone"
}

variable "region" {
  description = "region"
}

variable "replica_region" {
  description = "Replica region"
}

variable "db_user" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
}

variable "database_name" {
  description = "Database name"
}
