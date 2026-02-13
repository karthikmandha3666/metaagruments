variable "rgname" {
  description = "resource group name"
  type        = string
  default     = "az_sa_rg"
}

variable "location" {
  description = "Location"
  type        = string
  default     = "canadacentral"
}

variable "Vm_size" {
  description = "VMs size as per enviroment"
  type = string
  default = "Standard_B1s"
  }
  
variable "admin_user" {
    description = "VMs size as per enviroment"
  type = string
  default = "devopsUser"
}

variable "ssh_public_key_path" {
  description = "Public key to login"
  type = string
  default = "~/.ssh/azurekey.pub"
}

variable "Vm_count" {
  description = "No. of vm count"
  type = string
  default = 3
}