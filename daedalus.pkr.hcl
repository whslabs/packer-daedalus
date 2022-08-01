packer {
  required_plugins {
    # https://github.com/hashicorp/packer-plugin-ansible
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.3"
    }
    # https://github.com/hashicorp/packer-plugin-virtualbox
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.4"
    }
  }
}

source "virtualbox-iso" "daedalus" {
  disk_size        = 250000
  guest_os_type    = "Debian_64"
  http_directory   = "preseed"
  iso_checksum     = "c48b4ce1f5e4d62c2a42012aaae80db095163d8367b1c73a650499cf8521b4a7"
  iso_url          = "https://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/mini.iso"
  memory           = 2048
  shutdown_command = "sudo -S shutdown -P now"
  ssh_timeout      = "15m"
  ssh_username     = "packer"
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg SSH_PUBLIC_KEY={{ .SSHPublicKey | urlquery }}<enter>"
  ]
}

build {
  sources = ["sources.virtualbox-iso.daedalus"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook-virtualbox.yaml"
    use_proxy     = false
    user          = "packer"
  }
}
