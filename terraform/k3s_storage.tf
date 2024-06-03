resource "proxmox_vm_qemu" "k3s-storage-node" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "k3s Storage Node ${count.index + 1}"
    count = 3
    onboot = true

    # The template name to clone this vm from
    clone = "debian12-cloudinit-template"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 8192
    name = "k3s-storage-0${count.index + 1}"

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
            scsi1 {
              disk {
                storage = "TrueNAS"
                size = "512"
              }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr1"
        tag = 400
    }

    ipconfig0 = "ip=10.0.40.10${count.index + 7}/24,gw=10.0.40.1"

    ciuser = "debian"

    timeouts {
      create = "2h"
      update = "2h"
      delete = "20m"
    }

    connection {
      type = "ssh"
      agent = true
      host = "10.0.40.10${count.index + 7}"
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