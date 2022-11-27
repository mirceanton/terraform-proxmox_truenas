# =============================================
# GENERAL
# =============================================
variable "target_node" {
  type        = string
  description = "The name of the proxmox node on which to deploy the VM."
}

variable "vmid" {
  type        = number
  default     = 105
  description = "The id of the VM once deployed."
}

variable "name" {
  type        = string
  default     = "TrueNAS"
  description = "The name of the VM."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the VM."
}

variable "clone_id" {
  type        = number
  description = "The vmid of the VM to clone."
}

variable "auto_boot" {
  type        = bool
  default     = true
  description = "Whether or not the VM should start on boot."
}

# =============================================
# Resources
# =============================================
variable "cpu_cores" {
  type        = number
  default     = 4
  description = "The number of cpu cores to allocate to the VM."
}

variable "cpu_type" {
  type        = string
  default     = "host"
  description = "The emulated CPU type."
}

variable "memory" {
  type        = number
  default     = 8192
  description = "The amount of RAM in Mib to allocate to the VM."
}

# =============================================
# Network
# =============================================
variable "vmbridge" {
  type        = string
  default     = "vmbr0"
  description = "The vmbr interface on which the VM should bind."
}

# =============================================
# Storage
# =============================================
variable "disk_size" {
  type        = number
  default     = 16
  description = "The size of the disk."
}

variable "disk_storage" {
  type        = string
  description = "The underlying storage device on which to create the VM."
}
