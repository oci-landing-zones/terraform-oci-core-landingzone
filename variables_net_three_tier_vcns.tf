# ------------------------------------------------------
# ----- Networking - Three-tier VCN 1
#-------------------------------------------------------
variable "add_tt_vcn1" {
  type    = bool
  default = false
  description = "Click to add a three-tier VCN, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available."
}
variable "tt_vcn1_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
}
variable "tt_vcn1_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/20"]
  description = "Enter the list of CIDR blocks for the VCN."
}
variable "tt_vcn1_dns" {
  type    = string
  default = null
  description = "Enter the VCN DNS name."
}
variable "tt_vcn1_attach_to_drg" {
  type    = bool
  default = false
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}
variable "tt_vcn1_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}
variable "customize_tt_vcn1_subnets" {
  type    = bool
  default = false
  description = "Check to customize default subnets settings."
}
variable "tt_vcn1_web_subnet_name" {
  type    = string
  default = null
  description = "Enter the Web subnet name."
}
variable "tt_vcn1_web_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Web subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_web_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Web subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Check to make the Web subnet private. It is public by default."
}
variable "tt_vcn1_app_subnet_name" {
  type    = string
  default = null
  description = "Enter the Application subnet name."
}
variable "tt_vcn1_app_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Application subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_app_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Application subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_db_subnet_name" {
  type    = string
  default = null
  description = "Enter the Database subnet name."
}
variable "tt_vcn1_db_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Database subnet CIDR block. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_db_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Database subnet DNS name. Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn1_bastion_subnet" {
  type    = bool
  default = false
  description = "Check to to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn1_bastion_subnet_name" {
  type    = string
  default = null
  description = "Enter the Bastion subnet name."
}
variable "tt_vcn1_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn1_bastion_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn1_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If checked, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn1_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "These CIDRs are allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
}
variable "add_tt_vcn2" {
  type    = bool
  default = false
  description = "Click to add a three-tier VCN, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 2
#-------------------------------------------------------
variable "tt_vcn2_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
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
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}
variable "tt_vcn2_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}
variable "customize_tt_vcn2_subnets" {
  type    = bool
  default = false
  description = "Check to customize default subnets settings."
}
variable "tt_vcn2_web_subnet_name" {
  type    = string
  default = null
  description = "The load balancer subnet name."
}
variable "tt_vcn2_web_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_web_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "tt_vcn2_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether subnet is private or public."
}
variable "tt_vcn2_app_subnet_name" {
  type    = string
  default = null
  description = "The application subnet name."
}
variable "tt_vcn2_app_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_app_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "tt_vcn2_db_subnet_name" {
  type    = string
  default = null
  description = "The database subnet name."
}
variable "tt_vcn2_db_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_db_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn2_bastion_subnet" {
  type    = bool
  default = false
  description = "Check to to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn2_bastion_subnet_name" {
  type    = string
  default = null
  description = "Enter the Bastion subnet name."
}
variable "tt_vcn2_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn2_bastion_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn2_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If checked, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn2_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "These CIDRs are allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access."
}

variable "add_tt_vcn3" {
  type    = bool
  default = false
  description = "Click to add a three-tier VCN, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available."
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 3
#-------------------------------------------------------
variable "tt_vcn3_name" {
  type    = string
  default = null
  description = "Enter the VCN name. Otherwise a default name is provided. The label above should be used in the 'Routable VCNs' field of other VCNs for constraining network traffic in a Hub/Spoke topology."
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
  description = "Check to route private traffic to/from this VCN via a new or existing DRG."
}
variable "tt_vcn3_routable_vcns" {
  type    = list(string)
  default = []
  description = "Enter the VCN labels that this VCN can send traffic to. Only applicable for Hub/Spoke topology where a DRG is deployed as the hub."
}
variable "customize_tt_vcn3_subnets" {
  type    = bool
  default = false
  description = "Check to customize default subnets settings."
}
variable "tt_vcn3_web_subnet_name" {
  type    = string
  default = null
  description = "The load balancer subnet name."
}
variable "tt_vcn3_web_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_web_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "tt_vcn3_web_subnet_is_private" {
  type    = bool
  default = false
  description = "Whether subnet is private or public."
}
variable "tt_vcn3_app_subnet_name" {
  type    = string
  default = null
  description = "The application subnet name."
}
variable "tt_vcn3_app_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_app_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "tt_vcn3_db_subnet_name" {
  type    = string
  default = null
  description = "The database subnet name."
}
variable "tt_vcn3_db_subnet_cidr" {
  type    = string
  default = null
  description = "It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_db_subnet_dns" {
  type    = string
  default = null
  description = "Use only letters and numbers, no special characters."
}
variable "deploy_tt_vcn3_bastion_subnet" {
  type    = bool
  default = false
  description = "Check to to deploy a subnet where you can further deploy OCI Bastion service or a jump host."
}
variable "tt_vcn3_bastion_subnet_name" {
  type    = string
  default = null
  description = "Enter the Bastion subnet name."
}
variable "tt_vcn3_bastion_subnet_cidr" {
  type    = string
  default = null
  description = "Enter the Bastion subnet CIDR block. A /29 block is usually enough, unless you plan on deploying a large number of jump hosts. It must be within the VCN CIDR blocks."
}
variable "tt_vcn3_bastion_subnet_dns" {
  type    = string
  default = null
  description = "Enter the Bastion subnet DNS name. Use only letters and numbers, no special characters."
}
variable "tt_vcn3_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
  description = "If checked, the Bastion subnet is made public where you'd later deploy and manage your jump hosts. By default, the Bastion subnet is private, where OCI Bastion service is expected to be deployed."
}
variable "tt_vcn3_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
  description = "These CIDRs are allowed to SSH into the the jump host that is eventually deployed in the public Bastion subnet. Leave it empty for no access. 0.0.0.0/0 is not allowed."
}
