resource "proxmox_vm_qemu" "rke2-server-node" {
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"
    desc = "RKE2 Server ${count.index + 1}"
    count = 3
    onboot = true

    # The template name to clone this vm from
    clone = "ubuntu-cloud"

    # Activate QEMU agent for this VM
    agent = 0

    os_type = "cloud-init"
    cores = 1
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "rke2-server-0${count.index + 1}"

    cloudinit_cdrom_storage = "local-lvm"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local-lvm"
                  size = "20"
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