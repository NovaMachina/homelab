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
    memory = 4096
    name = "k3s-storage-0${count.index + 1}"

    cloudinit_cdrom_storage = "local-lvm"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local-lvm"
                  size = "32G"
                }
            }
            scsi1 {
              disk {
                storage = "TrueNAS"
                size = "1024G"
              }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr1"
        tag = 400
    }

    ciuser = "debian"

    timeouts {
      create = "2h"
      update = "2h"
      delete = "20m"
    }

    provisioner "local-exec" {
      command = "sudo rm -rf /etc/machine-id && sudo dbus-uuidgen --ensure=/etc/machine-id"
    }
}