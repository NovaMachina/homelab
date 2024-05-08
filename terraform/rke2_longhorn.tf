resource "proxmox_vm_qemu" "rke2-longhorn-node" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    count = 3
    onboot = true

    # The template name to clone this vm from
    clone = "ubuntu-cloud"

    # Activate QEMU agent for this VM
    agent = 0

    os_type = "cloud-init"
    cores = 2
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "rke2-longhorn-0${count.index + 1}"

    cloudinit_cdrom_storage = "TrueNAS"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "TrueNAS"
                  size = "256"
                }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr1"
        tag = 400
    }

    ciuser = "ubuntu"
}