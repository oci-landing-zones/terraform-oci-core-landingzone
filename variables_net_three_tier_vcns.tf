# ------------------------------------------------------
# ----- Networking - Three-tier VCN 1
#-------------------------------------------------------
variable "add_tt_vcn1" {
  type    = bool
  default = false
  description = "Whether to add a VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-1'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}
variable "tt_vcn1_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided. VCN label: TT-VCN-1."
}
variable "tt_vcn1_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}
variable "tt_vcn1_dns" {
  type    = string
  default = null
  description = "The VCN DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Leave unassigned for sending traffic to all VCNs. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-2, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "customize_tt_vcn1_subnets" {
  type    = bool
  default = false
  description = "If true, allows for the customization of default subnets settings. Only applicable to RMS deployments."
}
variable "tt_vcn1_web_subnet_name" {
  type    = string
  default = null
  description = "The Web subnet name."
}
variable "tt_vcn1_web_subnet_cidr" {
  type    = string
  default = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_web_subnet_dns" {
  type    = string
  default = null
  description = "The Web subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn1_app_subnet_name" {
  type    = string
  default = null
  description = "The Application subnet name."
}
variable "tt_vcn1_app_subnet_cidr" {
  type    = string
  default = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_app_subnet_dns" {
  type    = string
  default = null
  description = "The Application subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_db_subnet_name" {
  type    = string
  default = null
  description = "The Database subnet name."
}
variable "tt_vcn1_db_subnet_cidr" {
  type    = string
  default = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_db_subnet_dns" {
  type    = string
  default = null
  description = "The Database subnet DNS name. Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn1_bastion_subnet" {
  type    = bool
  default = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn1_bastion_subnet_name" {
  type    = string
  default = null
  description = "The Bastion subnet name."
}
variable "tt_vcn1_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_bastion_subnet_dns" {
  type    = string
  default = null
  description = "The Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn1_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "List of CIDR blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
}
variable "add_tt_vcn2" {
  type    = bool
  default = false
  description = "Whether to add a second VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-2'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 2
#-------------------------------------------------------
variable "tt_vcn2_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided. Label: TT-VCN-2."
}
variable "tt_vcn2_cidrs" {
  type    = list(string)
  default = ["10.1.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}
variable "tt_vcn2_dns" {
  type    = string
  default = null
  description = "The VCN DNS Name."
}
variable "tt_vcn2_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-3, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "customize_tt_vcn2_subnets" {
  type    = bool
  default = false
  description = "If true, allows for the customization of default subnets settings. Only applicable to RMS deployments."
}
variable "tt_vcn2_web_subnet_name" {
  type    = string
  default = null
  description = "The Web subnet name."
}
variable "tt_vcn2_web_subnet_cidr" {
  type    = string
  default = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_web_subnet_dns" {
  type    = string
  default = null
  description = "The Web subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn2_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn2_app_subnet_name" {
  type    = string
  default = null
  description = "The Application subnet name."
}
variable "tt_vcn2_app_subnet_cidr" {
  type    = string
  default = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_app_subnet_dns" {
  type    = string
  default = null
  description = "The Application subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn2_db_subnet_name" {
  type    = string
  default = null
  description = "The Database subnet name."
}
variable "tt_vcn2_db_subnet_cidr" {
  type    = string
  default = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_db_subnet_dns" {
  type    = string
  default = null
  description = "The Database subnet DNS name. Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn2_bastion_subnet" {
  type    = bool
  default = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn2_bastion_subnet_name" {
  type    = string
  default = null
  description = "The Bastion subnet name."
}
variable "tt_vcn2_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_bastion_subnet_dns" {
  type    = string
  default = null
  description = "The Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn2_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn2_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "List of CIDRs blocks allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
}

variable "add_tt_vcn3" {
  type    = bool
  default = false
  description = "Whether to add a third VCN configured for three-tier workload deployments, with up to four subnets: web (public by default), application (private), database (private). An optional subnet (private by default) for bastion deployment is also available. The added VCN is labelled 'TT-VCN-3'. The label should be used in the '*_routable_vcns' fields of other VCNs for constraining network traffic to those respective VCNs in a Hub/Spoke topology."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 3
#-------------------------------------------------------
variable "tt_vcn3_name" {
  type    = string
  default = null
  description = "The VCN name. If unassigned, a default name is provided. Label: TT-VCN-3."
}
variable "tt_vcn3_cidrs" {
  type    = list(string)
  default = ["10.2.0.0/20"]
  description = "The list of CIDR blocks for the VCN."
}
variable "tt_vcn3_dns" {
  type    = string
  default = null
  description = "The VCN DNS Name."
}
variable "tt_vcn3_attach_to_drg" {
  type    = bool
  default = false
  description = "If true, the VCN is attached to a DRG, enabling cross-vcn traffic routing."
}
variable "tt_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "The VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub. Valid values: TT-VCN-1, TT-VCN-2, EXA-VCN-1, EXA-VCN-2, EXA-VCN3, OKE-VCN-1, OKE-VCN-2, OKE-VCN-3."
}
variable "customize_tt_vcn3_subnets" {
  type    = bool
  default = false
  description = "If true, allows for the customization of default subnets settings. Only applicable to RMS deployments."
}
variable "tt_vcn3_web_subnet_name" {
  type    = string
  default = null
  description = "The Web subnet name."
}
variable "tt_vcn3_web_subnet_cidr" {
  type    = string
  default = null
  description = "The Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_web_subnet_dns" {
  type    = string
  default = null
  description = "The Web subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn3_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether the Web subnet private. It is public by default."
}
variable "tt_vcn3_app_subnet_name" {
  type    = string
  default = null
  description = "The Application subnet name."
}
variable "tt_vcn3_app_subnet_cidr" {
  type    = string
  default = null
  description = "The Application subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_app_subnet_dns" {
  type    = string
  default = null
  description = "The Application subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn3_db_subnet_name" {
  type    = string
  default = null
  description = "The Database subnet name."
}
variable "tt_vcn3_db_subnet_cidr" {
  type    = string
  default = null
  description = "The Database subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_db_subnet_dns" {
  type    = string
  default = null
  description = "The Database subnet DNS name. Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn3_bastion_subnet" {
  type    = bool
  default = false
  description = "Whether to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn3_bastion_subnet_name" {
  type    = string
  default = null
  description = "The Bastion subnet name."
}
variable "tt_vcn3_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "The Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_bastion_subnet_dns" {
  type    = string
  default = null
  description = "The Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn3_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If true, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn3_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "List of CIDRs allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. 0.0.0.0/0 is not allowed."
}
