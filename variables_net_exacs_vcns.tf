# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 1
#-------------------------------------------------------
variable "add_exa_vcn1" {
  type    = bool
  default = false
}

variable "exa_vcn1_name" {
  type    = string
  default = null
}
variable "exa_vcn1_cidrs" {
  type    = list(string)
  default = ["172.16.0.0/20"]
}

variable "exa_vcn1_attach_to_drg" {
  type    = bool
  default = false
}

variable "exa_vcn1_dns" {
  type    = string
  default = null
}

variable "exa_vcn1_client_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn1_client_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn1_client_subnet_dns" {
  type    = string
  default = null
}
variable "exa_vcn1_backup_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn1_backup_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn1_backup_subnet_dns" {
  type    = string
  default = null
}

variable "exa_vcn1_routable_vcns" {
  type    = list(string)
  default = []
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 2
#-------------------------------------------------------

variable "add_exa_vcn2" {
  type    = bool
  default = false
}

variable "exa_vcn2_cidrs" {
  type    = list(string)
  default = ["172.17.0.0/20"]
}

variable "exa_vcn2_attach_to_drg" {
  type    = bool
  default = false
}

variable "exa_vcn2_name" {
  default = ""
  type    = string
}
variable "exa_vcn2_dns" {
  default = ""
  type    = string
}
variable "exa_vcn2_client_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn2_client_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn2_client_subnet_dns" {
  type    = string
  default = null
}
variable "exa_vcn2_backup_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn2_backup_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn2_backup_subnet_dns" {
  type    = string
  default = null
}

variable "exa_vcn2_routable_vcns" {
  type    = list(string)
  default = []
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 3
#-------------------------------------------------------
variable "add_exa_vcn3" {
  type    = bool
  default = false
}

variable "exa_vcn3_cidrs" {
  type    = list(string)
  default = ["172.18.0.0/20"]
}

variable "exa_vcn3_attach_to_drg" {
  type    = bool
  default = false
}

variable "exa_vcn3_name" {
  type    = string
  default = ""
}
variable "exa_vcn3_dns" {
  type    = string
  default = ""
}
variable "exa_vcn3_client_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn3_client_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn3_client_subnet_dns" {
  type    = string
  default = null
}
variable "exa_vcn3_backup_subnet_cidr" {
  type    = string
  default = null
}
variable "exa_vcn3_backup_subnet_name" {
  type    = string
  default = null
}
variable "exa_vcn3_backup_subnet_dns" {
  type    = string
  default = null
}

variable "exa_vcn3_routable_vcns" {
  type    = list(string)
  default = []
}