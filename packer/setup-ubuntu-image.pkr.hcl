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

source "virtualbox-ovf" "ubuntu-setup" {
  source_path = "./output-ubuntu-base/base-vm-for-ubuntu-va.ovf"

  vm_name = "va_template_stand"
  ssh_username         = local.ssh_default_username
  ssh_private_key_file = var.ssh_private_key_file
  guest_additions_mode = "attach"
}

build {
  name = "setup_ubuntu"

  sources = [
    "source.virtualbox-ovf.ubuntu-setup"
  ]

  provisioner "shell" {
    inline = [
      "mkdir /mnt/iso",
      "mount /dev/sr0 /mnt/iso",
      "/mnt/iso/VBoxLinuxAdditions.run",
      "umount /mnt/iso",
      "rm -rf /mnt/iso"
    ]
    valid_exit_codes = [0, 2]
    execute_command = "sudo -E sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "shell-local" {
    pause_before = "10s" # Previous steps may cause ssh connection timeout
    inline = [
      "cd ../ansible; ansible-playbook playbooks/setup.yml -i inventory -l va_template_stand -vvv"
    ]
  }
}