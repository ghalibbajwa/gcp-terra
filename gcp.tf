
terraform {
  required_version = ">= 0.12"
}
provider "google" {
  project     = var.app_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region_1
  zone        = var.gcp_zone_1
}

resource "google_compute_network" "vpc" {
  name = "${var.app_name}-vpc"
  auto_create_subnetworks = "false" 
  routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "public_subnet_1" {
  
  name = "${var.app_name}-public-subnet-1"
  ip_cidr_range = var.public_subnet_cidr_1
  network = google_compute_network.vpc.name
  region = var.gcp_region_1
}


resource "google_compute_subnetwork" "public_subnet" {
  count= "${var.node_count}"
  name = "${var.app_name}-public-subnet-${count.index}"
  ip_cidr_range = "${var.public_subnet_cidr_2["${count.index}"]}"
  network = google_compute_network.vpc.name
  region = substr("${var.all_zones["${count.index}"]}", 0, length("${var.all_zones["${count.index}"]}")-2)
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "0-9999"]
  }
  allow {
    protocol = "udp"
    ports    = ["60000"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["web"]
}



resource "google_compute_firewall" "rules" {
  project     =  var.app_project
  name        = "my-firewall-rule"
  network     = google_compute_network.vpc.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol = "udp"
    ports    = ["60000"]
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "0-9999"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["foo"]
  target_tags = ["web"]
}


# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}
# Create VM #1
resource "google_compute_instance" "vm_instance_public" {
  name = "${var.app_name}-controller"
  machine_type = "e2-medium"
  zone = var.gcp_zone_1
  tags = ["ssh","http","web","foo"]
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-jammy-v20221206"
    }
  }
 metadata_startup_script = "curl -fsSL get.docker.com -o get-docker.sh; sudo sh get-docker.sh;"

  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name
    
  
  access_config { }
  }


}

# Create VM #2
resource "google_compute_instance" "vm_instance_public2" {
  count   = "${var.node_count}"
  name = "${var.app_name}-vm-agent-${count.index}"
  machine_type = "e2-micro"
  zone = "${var.all_zones["${count.index}"]}"
  tags = ["ssh","http","web","foo"]
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-jammy-v20221206"
    }
  }
 metadata_startup_script = "curl -fsSL get.docker.com -o get-docker.sh; sudo sh get-docker.sh; git clone https://github.com/slogr/slogr-twamp.git;cd slogr-twamp/agent/;sudo docker compose up -d"

  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet[count.index].name
    
  
  access_config { }
  }


}


# output "vm-name" {
#   value = google_compute_instance.vm_instance_public.name
# }
# output "vm-external-ip" {
#   value =   google_compute_instance.vm_instance_public.network_interface.0.access_config.0.nat_ip
# }
# output "vm-internal-ip" {
#   value = google_compute_instance.vm_instance_public.network_interface.0.network_ip
# }