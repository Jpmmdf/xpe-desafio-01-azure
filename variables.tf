variable "location_us" {
  description = "The Azure Region for US East resources."
  type        = string
  default     = "East US"
}

variable "location_brazil" {
  description = "The Azure Region for Brazil South resources."
  type        = string
  default     = "Brazil South"
}

variable "admin_username" {
  description = "The admin username of the virtual machine."
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "The admin password of the virtual machine."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_D2as_v5"
}

variable "address_space_vnet01" {
  description = "The address space for VNET01."
  type        = list(string)
  default     = ["10.0.0.0/20"]
}

variable "address_space_vnet02" {
  description = "The address space for VNET02."
  type        = list(string)
  default     = ["10.1.0.0/20"]
}

variable "managed_disk_size_gb" {
  description = "The size of the managed disk in GB."
  type        = number
  default     = 32
}
