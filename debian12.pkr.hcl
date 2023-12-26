packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type =  string
}

variable "proxmox_username" {
  type = string
  default = "root@pam"
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "proxmox_storage" {
  type = string
  default = "local-lvm"
}

variable "proxmox_node" {
  type = string
  default = "nuc"
}

source "proxmox-iso" "debian12" {
  template_description = "TEMPLATE :: Debian 12"
  template_name        = "TEMPLATE-DEBIAN12"
  vm_name              = "debian12-template-packer"

  boot_command            = ["<esc><wait>", "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed-debian12.cfg<enter>"]
  boot_wait               = "10s"
  cloud_init              = true
  cloud_init_storage_pool = "${var.proxmox_storage}"

  # Hardware setup
  os              = "l26"
  scsi_controller = "virtio-scsi-pci"
  memory          = 1024
  disks {
    disk_size    = "20G"
    storage_pool = "${var.proxmox_storage}"
    type         = "scsi"
  }
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  http_directory = "http"
  iso_file       = "local:iso/debian-12.4.0-amd64-netinst.iso"
  iso_checksum   = "64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
  unmount_iso    = true

  # Proxmox connection
  proxmox_url = "${var.proxmox_url}api2/json"
  node        = "${var.proxmox_node}"
  password    = "${var.proxmox_password}"
  username    = "${var.proxmox_username}"

  # Connecting for post proccess
  communicator = "ssh"
  ssh_password = "passw0rd"
  ssh_timeout  = "30m"
  ssh_username = "sysadmin"
}

build {
  sources = ["source.proxmox-iso.debian12"]

  provisioner "shell" {
    execute_command = "echo 'passw0rd' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/debian12-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'passw0rd' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/debian-cleanup.sh"
  }
}
