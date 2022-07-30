packer {
  required_plugins {
    # https://github.com/hashicorp/packer-plugin-ansible
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.3"
    }
    # https://github.com/hashicorp/packer-plugin-qemu
    qemu = {
      version = ">= 1.0.5"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "daedalus-qemu" {
  accelerator          = "kvm"
  disk_size            = "250G"
  http_directory       = "preseed"
  iso_checksum         = "c48b4ce1f5e4d62c2a42012aaae80db095163d8367b1c73a650499cf8521b4a7"
  iso_url              = "https://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/mini.iso"
  memory               = 2048
  shutdown_command     = "sudo -S shutdown -P now"
  ssh_private_key_file = "packer"
  ssh_timeout          = "15m"
  ssh_username         = "packer"
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg PACKER_AUTHORIZED_KEY_FILE=packer.pub<enter>"
  ]
  qemuargs = [
    ["-cpu", "host"],
  ]
}

build {
  sources = ["source.qemu.daedalus-qemu"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yaml"
    use_proxy     = false
    user          = "packer"
  }
}
