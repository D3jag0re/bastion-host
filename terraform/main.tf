# Set the variable value in *.tfvars file for local run
variable "do_token" {}

# Set up the variable value in *.tfvars file for local run
variable "public_key" {}
variable "public_key_priv" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# SSH Key - Bastion. In GHA Secrets
resource "digitalocean_ssh_key" "bastion_dynamic_key" {
  name       = "github-actions-key"
  public_key = var.public_key
}

# SSH Key - Private. In GHA Secrets
resource "digitalocean_ssh_key" "private_dynamic_key" {
  name       = "github-actions-key"
  public_key = var.public_key_priv
}

# Create a new VPC
resource "digitalocean_vpc" "bastion-vpc" {
  name     = "bastioon-vpc-network"
  region   = "nyc2"
  ip_range = "10.10.10.0/24"
}

# Create Firewall for Bastion Host 

resource "digitalocean_firewall" "bastionFW" {
  name = "bastionFW"

  droplet_ids = [digitalocean_droplet.bastion-host.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create Firewall for Private Server 

resource "digitalocean_firewall" "privateFW" {
  name = "privateFW"

  droplet_ids = [digitalocean_droplet.private-host.id]

  inbound_rule {
    protocol         = "tcp"
    source_addresses = ["10.10.10.0/24"]
  }

  inbound_rule {
    protocol         = "udp"
    source_addresses = ["10.10.10.0/24"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["10.10.10.0/24"]
  }

  outbound_rule {
    protocol              = "tcp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create Bastion Host
resource "digitalocean_droplet" "bastion-host" {
  image   = "ubuntu-22-04-x64"
  name    = "bastion-host"
  region  = "nyc2"
  size    = "s-1vcpu-1gb"
  backups = true
  vpc_uuid = digitalocean_vpc.bastion-vpc

  ssh_keys = [digitalocean_ssh_key.bastion_dynamic_key]
}

# Create Private Server
resource "digitalocean_droplet" "private-server" {
  image   = "ubuntu-22-04-x64"
  name    = "private-server"
  region  = "nyc2"
  size    = "s-1vcpu-1gb"
  backups = true
  vpc_uuid = digitalocean_vpc.bastion-vpc

  ssh_keys = [digitalocean_ssh_key.private_dynamic_key]
}


# Capture outputs of Bastion Droplet
output "bastion_info" {
  value = {
    id       = digitalocean_droplet.bastion-host.id
    name     = digitalocean_droplet.bastion-host.name
    ipv4     = digitalocean_droplet.bastion-host.ipv4_address
  }
}

# Capture outputs of Private Droplet
output "private_info" {
  value = {
    id       = digitalocean_droplet.private-server.id
    name     = digitalocean_droplet.private-server.name
    ipv4     = digitalocean_droplet.private-server.ipv4_address
  }
}

