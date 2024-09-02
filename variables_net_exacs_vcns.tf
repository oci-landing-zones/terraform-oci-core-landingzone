# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 1
#-------------------------------------------------------
variable "add_exa_vcn1" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private)."
}

variable "exa_vcn1_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
}
variable "exa_vcn1_cidrs" {
  type    = list(string)
  default = ["172.16.0.0/20"]
  description = "Enter the list of CIDR blocks for the VCN."
}

variable "exa_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "exa_vcn1_dns" {
  type    = string
  default = null
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "exa_vcn1_client_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_client_subnet_name" {
  type    = string
  default = null
  description = "Enter the Client subnet name."
}
variable "exa_vcn1_client_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn1_backup_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_backup_subnet_name" {
  type    = string
  default = null
  description = "Enter the Backup subnet name."
}
variable "exa_vcn1_backup_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 2
#-------------------------------------------------------

variable "add_exa_vcn2" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private)."
}

variable "exa_vcn2_cidrs" {
  type    = list(string)
  default = ["172.17.0.0/20"]
  description = "Enter the list of CIDR blocks for the VCN."
}

variable "exa_vcn2_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "exa_vcn2_name" {
  default = ""
  type    = string
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}
variable "exa_vcn2_dns" {
  default = ""
  type    = string
  description = "Enter the VCN DNS name."
}
variable "exa_vcn2_client_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_client_subnet_name" {
  type    = string
  default = null
  description = "Enter the Client subnet name."
}
variable "exa_vcn2_client_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn2_backup_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_backup_subnet_name" {
  type    = string
  default = null
  description = "Enter the Backup subnet name."
}
variable "exa_vcn2_backup_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 3
#-------------------------------------------------------
variable "add_exa_vcn3" {
  type    = bool
  default = false
  description = "Click to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private)."
}

variable "exa_vcn3_cidrs" {
  type    = list(string)
  default = ["172.18.0.0/20"]
  description = "Enter the list of CIDR blocks for the VCN."
}

variable "exa_vcn3_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}

variable "exa_vcn3_name" {
  type    = string
  default = ""
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}
variable "exa_vcn3_dns" {
  type    = string
  default = ""
  description = "Enter the VCN DNS name."
}
variable "exa_vcn3_client_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_client_subnet_name" {
  type    = string
  default = null
  description = "Enter the Client subnet name."
}
variable "exa_vcn3_client_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn3_backup_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_backup_subnet_name" {
  type    = string
  default = null
  description = "Enter the Backup subnet name."
}
variable "exa_vcn3_backup_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the Backup subnet DNS name. Use only letters and numbers, no special characters."
}