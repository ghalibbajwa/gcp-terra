# define the GCP authentication file
variable "gcp_auth_file" {
  type = string
  description = "GCP authentication file"
}
# define GCP project name
variable "app_project" {
  type = string
  description = "GCP project name"
}
# define GCP region
variable "gcp_region_1" {
  type = string
  description = "GCP region"
}
# define GCP zone
variable "gcp_zone_1" {
  type = string
  description = "GCP zone"
}
# define Public subnet
variable "public_subnet_cidr_1" {
  type = string
  description = "Public subnet CIDR 1"
}
variable "public_subnet_cidr_2" {
  default =[
     "10.10.3.0/24","10.10.4.0/24","10.10.5.0/24","10.10.6.0/24","10.10.7.0/24","10.10.8.0/24","10.10.9.0/24","10.10.10.0/24","10.10.11.0/24","10.10.12.0/24","10.10.13.0/24","10.10.14.0/24","10.10.15.0/24","10.10.16.0/24","10.10.17.0/24","10.10.18.0/24","10.10.19.0/24","10.10.20.0/24","10.10.21.0/24","10.10.22.0/24","10.10.23.0/24","10.10.24.0/24","10.10.25.0/24","10.10.26.0/24","10.10.27.0/24","10.10.28.0/24","10.10.29.0/24","10.10.30.0/24","10.10.31.0/24","10.10.32.0/24","10.10.33.0/24","10.10.34.0/24","10.10.35.0/24","10.10.36.0/24","10.10.37.0/24","10.10.38.0/24","10.10.39.0/24","10.10.40.0/24","10.10.41.0/24","10.10.42.0/24","10.10.43.0/24","10.10.44.0/24","10.10.45.0/24","10.10.46.0/24","10.10.47.0/24","10.10.48.0/24","10.10.49.0/24","10.10.50.0/24","10.10.51.0/24","10.10.52.0/24","10.10.53.0/24","10.10.54.0/24","10.10.55.0/24","10.10.56.0/24","10.10.57.0/24","10.10.58.0/24","10.10.59.0/24","10.10.60.0/24","10.10.61.0/24","10.10.62.0/24","10.10.63.0/24","10.10.64.0/24","10.10.65.0/24","10.10.66.0/24","10.10.67.0/24","10.10.68.0/24","10.10.69.0/24","10.10.70.0/24","10.10.71.0/24","10.10.72.0/24","10.10.73.0/24","10.10.74.0/24","10.10.75.0/24","10.10.76.0/24","10.10.77.0/24","10.10.78.0/24","10.10.79.0/24","10.10.80.0/24","10.10.81.0/24","10.10.82.0/24","10.10.83.0/24","10.10.84.0/24","10.10.85.0/24",
  ]
}
variable "app_name" {
  type = string
  description = "app name"
}
variable "node_count" {
  default = "28"
}

variable "all_zones" {
  # default = "us-east-1a",
  default = [
    "asia-east1-a", "asia-east2-a","asia-northeast1-a", "asia-northeast2-a", "asia-northeast3-a", "asia-south1-a","asia-south2-a", "asia-southeast1-a", "asia-southeast2-a","australia-southeast1-a", "australia-southeast2-a","europe-central2-a", "europe-north1-a", "europe-west1-d", "europe-west2-a","europe-west3-a", "europe-west4-a", "europe-west6-a","northamerica-northeast1-a", "southamerica-east1-a","us-central1-a", "us-central1-f", "us-east1-d","us-east4-a", "us-west1-a", "us-west2-a","us-west3-a", "us-west4-a"]
}