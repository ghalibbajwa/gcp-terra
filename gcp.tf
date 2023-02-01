
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
  
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["web"]
}



resource "google_compute_firewall" "rules" {
  project     =  var.app_project
  name        = "my-firewall-rule"
  network     = google_compute_network.vpc.name
  description = "Creates firewall rule targeting tagged instances"

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
  name = "${var.app_name}-vm-${random_id.instance_id.hex}"
  machine_type = "e2-micro"
  zone = var.gcp_zone_1
  tags = ["ssh","http","web","foo"]
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-jammy-v20221206"
    }
  }
 metadata_startup_script = "sudo apt update;sudo apt-get remove -y --purge man-db; sudo apt install python3-pip -y; curl -o slogr http://34.123.52.185/slogr; curl -o slogr.service http://34.123.52.185/slogr.service; curl -o app.py http://34.123.52.185/app.py; curl -o flask.service http://34.123.52.185/flask.service; chmod +x slogr; chmod +x slogr.service; chmod +x flask.service; chmod +x app.py; pip install flask; sudo cp flask.service /etc/systemd/system/; sudo cp slogr.service /etc/systemd/system/; sudo systemctl start slogr.service; sudo systemctl start flask.service"

  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name
    
  
  access_config { }
  }


}
# resource "random_id" "instance_id2" {
#   byte_length = 4
# }
# # Create VM #2
# resource "google_compute_instance" "vm_instance_public2" {
#   name = "${var.app_name}-vm-${random_id.instance_id2.hex}"
#   machine_type = "e2-micro"
#   zone = "us-central1-a"
#   tags = ["ssh","http","web","foo"]
  
#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-jammy-v20221206"
#     }
#   }
#  metadata_startup_script = "sudo apt update;sudo apt-get remove -y --purge man-db; sudo apt install python3-pip -y; curl -o slogr http://34.123.52.185/slogr; curl -o slogr.service http://34.123.52.185/slogr.service; curl -o app.py http://34.123.52.185/app.py; curl -o flask.service http://34.123.52.185/flask.service; chmod +x slogr; chmod +x slogr.service; chmod +x flask.service; chmod +x app.py; pip install flask; sudo cp flask.service /etc/systemd/system/; sudo cp slogr.service /etc/systemd/system/; sudo systemctl start slogr.service; sudo systemctl start flask.service"

#   network_interface {
#     network = google_compute_network.vpc.name
#     subnetwork = google_compute_subnetwork.public_subnet_1.name
    
  
#   access_config { }
#   }


# }


output "vm-name" {
  value = google_compute_instance.vm_instance_public.name
}
output "vm-external-ip" {
  value =   google_compute_instance.vm_instance_public.network_interface.0.access_config.0.nat_ip
}
output "vm-internal-ip" {
  value = google_compute_instance.vm_instance_public.network_interface.0.network_ip
}