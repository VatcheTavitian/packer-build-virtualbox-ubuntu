packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "os_username" {
  type      = string
  default   = "ubuntu"
  sensitive = true
}

variable "os_password" {
  type      = string
  default   = "ubuntu"
  sensitive = true
}

variable "vm_version" {
  type      = string
  default   = "1"
  sensitive = true
}

variable "vm_description" {
  type      = string
  default   = "Custom user VM"
  sensitive = true
}


locals {
  #hashed_os_password = bcrypt("${var.os_password}")
  hashed_os_password = "$2a$10$ZeBn/VIT9u1c1svv4iFRru1XaYVbfaH8nMQtB/oCat6oFodrL./d6"
}

source "virtualbox-iso" "ubuntu-24-live-server" {
  boot_command = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del><del><wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<enter><f10><wait>"
  ]
  boot_wait     = "5s"
  guest_os_type = "ubuntu-64"
  http_content = {
    "/meta-data" = file("./http/meta-data")
    "/user-data" = file("./http/user-data")
  }
  iso_url                = "https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso"
  iso_checksum           = "sha256:c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
  memory                 = 1024
  output_directory       = "./output/"
  shutdown_command       = "sudo shutdown -P now"
  ssh_handshake_attempts = "350"
  ssh_pty                = true
  ssh_timeout            = "20m"
  ssh_username           = "${var.os_username}"
  ssh_password           = "${var.os_password}"
  communicator           = "ssh"

  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "${var.vm_description}",
    "--version", "${var.vm_version}"
  ]
  format = "ova"

}

build {
  sources = ["sources.virtualbox-iso.ubuntu-24-live-server"]

  provisioner "shell" {
    inline = [
      "echo Success"
    ]
  }

  #post-processor "vagrant" {
  #  output = "./output/ubuntu-2404-live-server.box"
  #}
}

