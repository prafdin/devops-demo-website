packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

locals {
  ssh_default_username = "user"
  ssh_default_password = "P@ssw0rd"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Token for connect to frp server"
  default     = "id_rsa"
}

variable "ssh_public_key_file" {
  type        = string
  description = "Token for connect to frp server"
  default     = "id_rsa.pub"
}

source "virtualbox-iso" "ubuntu-base" {
  # VM Configuration
  vm_name              = "base-vm-for-ubuntu-va"
  guest_os_type        = "Ubuntu_64"
  cpus                 = 2
  memory               = 6048
  disk_size            = 9480
  hard_drive_interface = "sata"
  
  # ISO Configuration
  iso_url      = "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso"
  iso_checksum = "file:https://releases.ubuntu.com/24.04/SHA256SUMS"
  
  # SSH Configuration
  ssh_username         = local.ssh_default_username
  ssh_private_key_file = var.ssh_private_key_file
  ssh_timeout          = "60m"
  ssh_handshake_attempts = 420
  
  boot_wait = "5s"

  boot_command = ["e<wait><down><down><down><end> autoinstall 'ds=nocloud;s=http://{{.HTTPIP}}:{{.HTTPPort}}/'<F10>"]

  # HTTP Configuration for autoinstall
  http_content = {
    "/user-data"     = templatefile(
      "http/user-data.pkrtpl.hcl",
      {
        authorized_key = file(var.ssh_public_key_file)
      }
    )
     # file("http/user-data")
    "/meta-data"     = file("http/meta-data")
    "/vendor-data"     = file("http/vendor-data")
  }

  http_port_min  = 8000
  http_port_max  = 8100
  
  shutdown_command = "echo '${local.ssh_default_password}' | sudo -S shutdown -P now"
  
  # Export Configuration
  format = "ovf"
  export_opts = [
    "--manifest",
    "--vsys", "0", 
    "--description", "Ubuntu 24.04 Server with additional configuration",
    "--version", "1.0"
  ]

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--memory", "6024"],
    ["modifyvm", "{{.Name}}", "--vram", "16"],
    ["modifyvm", "{{.Name}}", "--nic2", "hostonly", "--hostonlyadapter2", "vboxnet0"],
  ]
}

build {
  name = "ubuntu"
  sources = [
    "source.virtualbox-iso.ubuntu-base"
  ]

  provisioner "shell" {
    execute_command = "echo '${local.ssh_default_password}' | sudo -S /bin/bash -c '{{ .Vars }} {{ .Path }}'"
    inline_shebang = "/bin/bash -e"
    inline = [
      "echo 'Waiting for system to be ready...'",
      "sleep 10",
      "tee /etc/sudoers.d/${local.ssh_default_username} <<< '${local.ssh_default_username} ALL=(ALL) NOPASSWD: ALL'",
      "apt update"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python3 python3-pip"
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
