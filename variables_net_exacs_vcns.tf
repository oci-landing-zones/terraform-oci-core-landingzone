# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 1
#-------------------------------------------------------
variable "add_exa_vcn1" {
  type    = bool
  default = false
  description = "Whether to add a VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}

variable "exa_vcn1_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-1."
}
variable "exa_vcn1_cidrs" {
  type    = list(string)
  default = ["172.16.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}

variable "exa_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "exa_vcn1_dns" {
  type    = string
  default = null
  description = "The VCN DNS name."
}

variable "exa_vcn1_client_subnet_cidr" {
  type    = string
  default = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_client_subnet_name" {
  type    = string
  default = null
  description = "The Client subnet name."
}
variable "exa_vcn1_client_subnet_dns" {
  type    = string
  default = null
  description = "The Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn1_backup_subnet_cidr" {
  type    = string
  default = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn1_backup_subnet_name" {
  type    = string
  default = null
  description = "The Backup subnet name."
}
variable "exa_vcn1_backup_subnet_dns" {
  type    = string
  default = null
  description = "The Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 2
#-------------------------------------------------------

variable "add_exa_vcn2" {
  type    = bool
  default = false
  description = "Whether to add a second VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}

variable "exa_vcn2_cidrs" {
  type    = list(string)
  default = ["172.17.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}

variable "exa_vcn2_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "exa_vcn2_name" {
  default = ""
  type    = string
  description = "The VCN name. If unassigned, a default name is provided. VCN label: EXA-VCN-2"
}
variable "exa_vcn2_dns" {
  default = ""
  type    = string
  description = "The VCN DNS name."
}
variable "exa_vcn2_client_subnet_cidr" {
  type    = string
  default = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_client_subnet_name" {
  type    = string
  default = null
  description = "The Client subnet name."
}
variable "exa_vcn2_client_subnet_dns" {
  type    = string
  default = null
  description = "The Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn2_backup_subnet_cidr" {
  type    = string
  default = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn2_backup_subnet_name" {
  type    = string
  default = null
  description = "The Backup subnet name."
}
variable "exa_vcn2_backup_subnet_dns" {
  type    = string
  default = null
  description = "The Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}

# ------------------------------------------------------
# ----- Networking - Exadata Cloud Service VCN 3
#-------------------------------------------------------
variable "add_exa_vcn3" {
  type    = bool
  default = false
  description = "Whether to add a third VCN configured for Exadata Cloud Service deployment, with two subnets: client (private) and backup (private). The added VCN is labelled 'EXA-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}

variable "exa_vcn3_cidrs" {
  type    = list(string)
  default = ["172.18.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}

variable "exa_vcn3_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}

variable "exa_vcn3_name" {
  type    = string
  default = ""
  description = "The VCN name. If unassigned, a default name is provided. Label: EXA-VCN-3."
}
variable "exa_vcn3_dns" {
  type    = string
  default = ""
  description = "The VCN DNS name."
}
variable "exa_vcn3_client_subnet_cidr" {
  type    = string
  default = null
  description = "The Client subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_client_subnet_name" {
  type    = string
  default = null
  description = "The Client subnet name."
}
variable "exa_vcn3_client_subnet_dns" {
  type    = string
  default = null
  description = "The Client subnet DNS name. Use only letters and numbers, no special characters."
}
variable "exa_vcn3_backup_subnet_cidr" {
  type    = string
  default = null
  description = "The Backup subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "exa_vcn3_backup_subnet_name" {
  type    = string
  default = null
  description = "The Backup subnet name."
}
variable "exa_vcn3_backup_subnet_dns" {
  type    = string
  default = null
  description = "The Backup subnet DNS name. Use only letters and numbers, no special characters."
}

variable "exa_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN2, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}