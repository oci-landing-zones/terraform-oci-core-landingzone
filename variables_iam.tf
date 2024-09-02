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
  description = "Select the existing compartment where Landing Zone enclosing compartment is created."
}
variable "existing_enclosing_compartment_ocid" {
  type        = string
  default     = null
  description = "Select the existing compartment where Landing Zone compartments (Network, Security, App, Database) are created."
}
variable "deploy_exainfra_cmp" {
  type    = bool
  default = false
  description = "Whether a separate compartment for Exadata Cloud Service Infrastructure is deployed."
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
  description = "Existing group to which IAM management policies will be granted to."
}

variable "rm_existing_cred_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_cred_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which credentials management policies will be granted to."
}

variable "rm_existing_security_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_security_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which security management policies will be granted to."
}


variable "rm_existing_network_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_network_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which network management policies will be granted to."
}

variable "rm_existing_appdev_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_appdev_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which application development management policies will be granted to."
}

variable "rm_existing_database_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_database_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which database management policies will be granted to."
}

variable "rm_existing_auditor_group_name" {
  type    = string
  default = ""
}
variable "existing_auditor_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which auditing policies will be granted to."
}

variable "rm_existing_announcement_reader_group_name" {
  type    = string
  default = ""
}
variable "existing_announcement_reader_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which announcement reading policies will be granted to."
}

variable "rm_existing_exainfra_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_exainfra_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which Exadata infrastructure management policies will be granted to."
}

variable "rm_existing_cost_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_cost_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which Cost management policies will be granted to."
}

variable "rm_existing_storage_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_storage_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which Storage management policies will be granted to."
}

variable "rm_existing_ag_admin_group_name" {
  type    = string
  default = ""
}
variable "existing_ag_admin_group_name" {
  type        = list(string)
  default     = []
  description = "Existing group to which Access Governance management policies will be granted to."
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
  description = "Existing security dynamic group to run functions."
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
  description = "Existing network firewall appliance dynamic group for reading firewall instances."
}

# ------------------------------------------------------
# ----- IAM - Policies
#-------------------------------------------------------
variable "policies_in_root_compartment" {
  type        = string
  default     = "CREATE"
  description = "Whether policies in the Root compartment should be created or simply used. If 'CREATE', you must be sure the user executing this stack has permissions to create policies in the Root compartment. If 'USE', policies must have been created previously."
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