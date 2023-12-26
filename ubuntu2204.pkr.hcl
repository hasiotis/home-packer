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

source "proxmox-iso" "ubuntu2204" {
  template_description = "TEMPLATE :: Ubuntu 22.04"
  template_name        = "TEMPLATE-UBUNTU2204"
  vm_name              = "ubuntu2204-template-packer"

  boot_command            = ["c", "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ", "<enter><wait><wait>", "initrd /casper/initrd", "<enter><wait><wait>", "boot<enter>"]
  boot_wait               = "5s"
  cloud_init              = true
  cloud_init_storage_pool = "${var.proxmox_storage}"

  # Hardware setup
  os              = "l26"
  scsi_controller = "virtio-scsi-pci"
  memory          = 2048
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
  iso_file       = "local:iso/ubuntu-22.04.3-live-server-amd64.iso"
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
  sources = ["source.proxmox-iso.ubuntu2204"]

  provisioner "shell" {
    execute_command = "echo 'passw0rd' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/ubuntu-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'passw0rd' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "scripts/ubuntu-cleanup.sh"
  }
}
