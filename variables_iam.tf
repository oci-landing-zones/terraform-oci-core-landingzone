# ------------------------------------------------------
# ----- IAM - Base Compartments
#-------------------------------------------------------
variable "enclosing_compartment_options" {
  type    = string
  default = "Yes, deploy new"
}
variable "enclosing_compartment_parent_ocid" {
  type        = string
  default     = null
  description = "The enclosing compartment parent compartment OCID."
}
variable "existing_enclosing_compartment_ocid" {
  type        = string
  default     = null
  description = "The enclosing compartment OCID where Landing Zone compartments will be created. If not provided and use_enclosing_compartment is true, an enclosing compartment is created under the root compartment."
}
variable "deploy_exainfra_cmp" {
  type    = bool
  default = false
  description = "Whether a separate compartment for Exadata Cloud Infrastructure is deployed."
}

# ------------------------------------------------------
# ----- IAM - Identity Domains
#-------------------------------------------------------
variable "use_custom_id_domain" {
  type    = bool
  default = false
}
variable "custom_id_domain_name" {
  type    = string
  default = null
}
variable "rm_existing_id_domain_iam_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_cred_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_security_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_network_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_appdev_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_database_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_auditor_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_announcement_reader_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_exainfra_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_cost_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_storage_admin_group_name" {
  type    = list(string)
  default = []
}
variable "rm_existing_id_domain_ag_admin_group_name" {
  type    = list(string)
  default = []
}
variable "existing_id_domain_security_fun_dyn_group_name" {
  type    = string
  default = ""
}
variable "existing_id_domain_appdev_fun_dyn_group_name" {
  type    = string
  default = ""
}
variable "existing_id_domain_compute_agent_dyn_group_name" {
  type    = string
  default = ""
}
variable "existing_id_domain_database_kms_dyn_group_name" {
  type    = string
  default = ""
}
variable "existing_id_domain_net_fw_app_dyn_group_name" {
  type    = string
  default = ""
}

# variable "deploy_id_domain" {
#   type    = bool
#   default = false
# }
# variable "id_domain_name" {
#   type    = string
#   default = null
# }
# variable "id_domain_type" {
#   type    = string
#   default = "free"
# }
# variable "use_id_domain_groups_to_manage_tenancy" {
#   type    = bool
#   default = false
# }

# ------------------------------------------------------
# ----- IAM - Groups
#-------------------------------------------------------
variable "groups_options" {
  type    = string
  default = "Yes"
}
variable "rm_existing_iam_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_iam_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for iam administrators."
}

variable "rm_existing_cred_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_cred_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for credential administrators."
}

variable "rm_existing_security_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_security_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for security administrators."
}


variable "rm_existing_network_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_network_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for network administrators."
}

variable "rm_existing_appdev_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_appdev_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for appdev administrators."
}

variable "rm_existing_database_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_database_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for database administrators."
}

variable "rm_existing_auditor_group_name" {
  type    = string
  default = ""
}
variable "existing_auditor_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for auditors."
}

variable "rm_existing_announcement_reader_group_name" {
  type    = string
  default = ""
}
variable "existing_announcement_reader_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for announcement readers."
}

variable "rm_existing_exainfra_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_exainfra_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for exainfra administrators."
}

variable "rm_existing_cost_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_cost_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for cost administrators."
}

variable "rm_existing_storage_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_storage_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for storage administrators."
}

variable "rm_existing_ag_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_ag_admin_group_name" {
  type        = list(string)
  default     = []
  description = "List of groups for iam administrators."
}

# ------------------------------------------------------
# ----- IAM - Dynamic Groups
#-------------------------------------------------------
variable "dyn_groups_options" {
  type    = string
  default = "Yes"
}
variable "existing_security_fun_dyn_group_name" {
  type        = string
  default     = ""
  description = "Existing security dynamic group."
}
variable "existing_appdev_fun_dyn_group_name" {
  type        = string
  default     = ""
  description = "Existing appdev dynamic group."
}
variable "existing_compute_agent_dyn_group_name" {
  type        = string
  default     = ""
  description = "Existing compute agent dynamic group for management agent access."
}
variable "existing_database_kms_dyn_group_name" {
  type        = string
  default     = ""
  description = "Existing database dynamic group for database to access keys."
}
variable "existing_net_fw_app_dyn_group_name" {
  type        = string
  default     = ""
  description = "Existing network firewall appliance group for reading firewall instances."
}

# ------------------------------------------------------
# ----- IAM - Policies
#-------------------------------------------------------
variable "policies_in_root_compartment" {
  type        = string
  default     = "CREATE"
  description = "Whether required grants at the Root compartment should be created or simply used. Valid values: 'CREATE' and 'USE'. If 'CREATE', make sure the user executing this stack has permissions to create grants in the Root compartment. If 'USE', no grants are created."
  validation {
    condition     = contains(["CREATE", "USE"], var.policies_in_root_compartment)
    error_message = "Validation failed for policies_in_root_compartment: valid values are CREATE or USE."
  }
}

# variable "enable_template_policies" {
#   type        = bool
#   default     = false
#   description = "Whether policies should be created based on metadata associated to compartments. This is an alternative way of managing policies, enabled by the CIS Landing Zone standalone IAM policy module: https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/tree/main/policies. When set to true, the grants to resources belonging to a specific compartment are combined into a single policy that is attached to the compartment itself. This differs from the default approach, where grants are combined per grantee and attached to the enclosing compartment."
# }