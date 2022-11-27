# Terraform Template: PVE TrueNAS

A Terraform template that deploys a TrueNAS VM on a Proxmox VE host.

## Requirements

- A Proxmox VE Host
- A machine with Hashicorp Terraform
- A network connection between the PVE host and the terraform machine
- An TrueNAS VM template on the PVE host

To create the VM template, take a look at this [packer template](https://github.com/mirceanton/packer-proxmox_truenas).

## Getting Started

- Clone this repo
- Create a `.auto.tfvars` file and customize it
- Run the `terraform init` command
- Run the `terraform apply` command

### Variables

Here's an empty sample for the `.auto.tfvars` file, for you to customize:

``` hcl
# =============================================
# PROXMOX CONNECTION
# =============================================
proxmox_url = ""
proxmox_username = ""
proxmox_password = ""

# =============================================
# GENERAL
# =============================================
target_node = ""
vmid = ""
name = ""
description = ""
clone_id = ""
auto_boot = ""

# =============================================
# Resources
# =============================================
cpu_cores = ""
cpu_type = ""
memory = ""

# =============================================
# Network
# =============================================
vmbridge = ""

# =============================================
# Storage
# =============================================
disk_size = ""
disk_storage = ""
```

## Advanced Usage

For a more advanced usage, see the `templates/` directory. Inside, there are some jinja2 templated versions of the same `.tf` files that allow for more granular customization.

They are intended to be formatted by an Ansible task, such as:

``` yml
- name: Provision a TrueNAS VM
  hosts: localhost
  become: true
  gather_facts: false

  vars:
    proxmox_url: "https://1.2.3.4:8006/api2/json"
    proxmox_username: "username"
    proxmox_password: "password"
    truenas_vm_target_node: pve01
    truenas_vm_id: 105
    truenas_vm_clone_id: 1100
    truenas_vm_networks:
      - bridge: vmbr0
    truenas_vm_disks:
      - size: 32G
        storage: local-zfs

  tasks:
    - name: Clone the terraform-proxmox_terraform repo
      ansible.builtin.git:
        repo: https://github.com/mirceanton/terraform-proxmox_truenas
        dest: /opt/terraform-proxmox_truenas

    - name: Create template output directory
      ansible.builtin.file:
        path: /opt/terraform-proxmox_truenas/template-output
        state: directory

    - name: Templatize provider file
      ansible.builtin.template:
        src: /opt/terraform-proxmox_truenas/templates/provider.tf.j2
        dest: /opt/terraform-proxmox_truenas/template-output/provider.tf

    - name: Templatize resource file
      ansible.builtin.template:
        src: /opt/terraform-proxmox_truenas/templates/main.tf.j2
        dest: /opt/terraform-proxmox_truenas/template-output/main.tf

    - name: Run Terraform
      community.general.terraform:
        project_path: /opt/terraform-proxmox_truenas/template-output
        force_init: true
```

### Variables

For more details on certain variables, refer to the official module [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu).

``` yml
# Proxmox Connection Params
proxmox_url:                    # [Required] The URL for the Proxmox API endpoint
                                    # Format: https://a.b.c.d:8006
proxmox_username:                    # [Required] The username to authenticate
proxmox_password:                    # [Required] The password for the given username

# TrueNAS VM Params
truenas_vm_name: TrueNAS          # [Optional] The name of the VM
truenas_vm_target_node:            # [Required] The name of the node on which to deploy the VM
truenas_vm_id: 105                 # [Optional] The ID of the VM
truenas_vm_autoboot: true          # [Optional] Whether or not to start the VM on boot
truenas_vm_clone_id: 1100          # [Optional] The name of the VM to clone
truenas_vm_cpu_type: host          # [Optional] The type of CPU to assign to the VM
truenas_vm_cpu_cores: 4            # [Optional] The number of threads to assign to the VM
truenas_vm_memory: 8192            # [Optional] The amount of RAM in mb to assign to the VM
truenas_vm_vga_type: qxl           # [Optional] The type of VGA device. 
truenas_vm_vga_memory: 64          # [Optional] Sets the VGA memory (in MiB). Has no effect with serial display type.
truenas_vm_disks:                  # [Required] List of disks to assign to the VM 
  - size: 32              # [Required] The size of the disk in Gb
    storage: "local-zfs"  # [Required] The storage device for the VM
truenas_vm_networks:           # [Required] List of network devices
  - bridge: vmbr0     # [Required] The name of the network bridge to attach to. (vmbr0, vmbr1 etc)
    model: virtio     # [Optional] The NIC model

# TrueNAS Pool
truenas_vm_pool: Storage
```

## License

MIT

## Author Information

A template developed by [Mircea-Pavel ANTON](https://www.mirceanton.com).
