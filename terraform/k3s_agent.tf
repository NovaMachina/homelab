resource "proxmox_vm_qemu" "k3s-agent-node" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "k3s General Agent ${count.index + 1}"
    count = 3
    onboot = true

    # The template name to clone this vm from
    clone = "debian12-cloudinit-template"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 4
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 8192
    name = "k3s-agent-0${count.index + 1}"

    cloudinit_cdrom_storage = "local-lvm"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local-lvm"
                  size = "32"
                  emulatessd = true
                }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr1"
        tag = 400
    }

    ipconfig0 = "ip=10.0.40.10${count.index + 4}/24,gw=10.0.40.1"

    ciuser = "debian"

    connection {
      type = "ssh"
      agent = true
      host = "10.0.40.10${count.index + 4}"
      user = "debian"
      private_key = file(pathexpand("~/.ssh/id_rsa"))
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo ${var.sudo_password} | sudo -S rm -rf /etc/machine-id",
            "echo ${var.sudo_password} | sudo -S dbus-uuidgen --ensure=/etc/machine-id",
         ]
    }
}