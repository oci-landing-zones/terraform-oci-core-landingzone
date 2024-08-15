# ------------------------------------------------------
# ----- Networking - Three-tier VCN 1
#-------------------------------------------------------
variable "add_tt_vcn1" {
  type    = bool
  default = false
}
variable "tt_vcn1_name" {
  type    = string
  default = null
}
variable "tt_vcn1_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/20"]
}
variable "tt_vcn1_dns" {
  type    = string
  default = null
}
variable "tt_vcn1_attach_to_drg" {
  type    = bool
  default = false
}
variable "tt_vcn1_routable_vcns" {
  type    = list(string)
  default = []
}
variable "customize_tt_vcn1_subnets" {
  type    = bool
  default = false
}
variable "tt_vcn1_web_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn1_web_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn1_web_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn1_web_subnet_is_private" {
  type    = bool
  default = false
}
variable "tt_vcn1_app_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn1_app_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn1_app_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn1_db_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn1_db_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn1_db_subnet_dns" {
  type    = string
  default = null
}
variable "deploy_tt_vcn1_bastion_subnet" {
  type    = bool
  default = false
}
variable "tt_vcn1_bastion_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn1_bastion_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn1_bastion_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn1_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
}
variable "tt_vcn1_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
}
variable "add_tt_vcn2" {
  type    = bool
  default = false
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 2
#-------------------------------------------------------
variable "tt_vcn2_name" {
  type    = string
  default = null
}
variable "tt_vcn2_cidrs" {
  type    = list(string)
  default = ["10.1.0.0/20"]
}
variable "tt_vcn2_dns" {
  type    = string
  default = null
}
variable "tt_vcn2_attach_to_drg" {
  type    = bool
  default = false
}
variable "tt_vcn2_routable_vcns" {
  type    = list(string)
  default = []
}
variable "customize_tt_vcn2_subnets" {
  type    = bool
  default = false
}
variable "tt_vcn2_web_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn2_web_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn2_web_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn2_web_subnet_is_private" {
  type    = bool
  default = false
}
variable "tt_vcn2_app_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn2_app_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn2_app_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn2_db_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn2_db_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn2_db_subnet_dns" {
  type    = string
  default = null
}
variable "deploy_tt_vcn2_bastion_subnet" {
  type    = bool
  default = false
}
variable "tt_vcn2_bastion_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn2_bastion_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn2_bastion_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn2_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
}
variable "tt_vcn2_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "add_tt_vcn3" {
  type    = bool
  default = false
}

# ------------------------------------------------------
# ----- Networking - Three-tier VCN 3
#-------------------------------------------------------
variable "tt_vcn3_name" {
  type    = string
  default = null
}
variable "tt_vcn3_cidrs" {
  type    = list(string)
  default = ["10.2.0.0/20"]
}
variable "tt_vcn3_dns" {
  type    = string
  default = null
}
variable "tt_vcn3_attach_to_drg" {
  type    = bool
  default = false
}
variable "tt_vcn3_routable_vcns" {
  type    = list(string)
  default = []
}
variable "customize_tt_vcn3_subnets" {
  type    = bool
  default = false
}
variable "tt_vcn3_web_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn3_web_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn3_web_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn3_web_subnet_is_private" {
  type    = bool
  default = false
}
variable "tt_vcn3_app_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn3_app_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn3_app_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn3_db_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn3_db_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn3_db_subnet_dns" {
  type    = string
  default = null
}
variable "deploy_tt_vcn3_bastion_subnet" {
  type    = bool
  default = false
}
variable "tt_vcn3_bastion_subnet_name" {
  type    = string
  default = null
}
variable "tt_vcn3_bastion_subnet_cidr" {
  type    = string
  default = null
}
variable "tt_vcn3_bastion_subnet_dns" {
  type    = string
  default = null
}
variable "tt_vcn3_bastion_is_access_via_public_endpoint" {
  type    = bool
  default = false
}
variable "tt_vcn3_bastion_subnet_allowed_cidrs" {
  type    = list(string)
  default = []
}
