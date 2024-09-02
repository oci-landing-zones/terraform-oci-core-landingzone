# ------------------------------------------------------
# ----- IAM - Base Compartments
#-------------------------------------------------------
variable "enclosing_compartment_options" {
  type    = string
  default = "Yes, deploy new"
  description = "Determines where the landing zone compartments are deployed: within a new enclosing compartment or within an existing select enclosing compartment (that can be the Root compartment). Valid options: 'Yes, deploy new', 'Yes, use existing', 'No'"
}
variable "enclosing_compartment_parent_ocid" {
  type        = string
  default     = null
  description = "The existing compartment where Landing Zone enclosing compartment is created."
}
variable "existing_enclosing_compartment_ocid" {
  type        = string
  default     = null
  description = "The existing compartment where Landing Zone compartments (Network, Security, App, Database) are created."
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
  description = "Whether to use an existing identity domain with groups and dynamic groups to grant landing zone IAM policies. If false, groups and dynamic groups from the Default identity domain are utilized."
}
variable "custom_id_domain_name" {
  type    = string
  default = null
  description = "The existing identity domain name."
}
variable "rm_existing_id_domain_iam_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing IAM admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_cred_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing credentials admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_security_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing security admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_network_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing network admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_appdev_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing applications admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_database_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing database admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_auditor_group_name" {
  type    = list(string)
  default = []
  description = "The existing auditor group name in the existing identity domain."
}
variable "rm_existing_id_domain_announcement_reader_group_name" {
  type    = list(string)
  default = []
  description = "The existing announcement readers group name in the existing identity domain."
}
variable "rm_existing_id_domain_exainfra_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing Exadata CS infrastructure admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_cost_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing cost admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_storage_admin_group_name" { 
  type    = list(string)
  default = []
  description = "The existing storage admin group name in the existing identity domain."
}
variable "rm_existing_id_domain_ag_admin_group_name" {
  type    = list(string)
  default = []
  description = "The existing access governance admin group name in the existing identity domain."
}
variable "existing_id_domain_security_fun_dyn_group_name" {
  type    = string
  default = ""
  description = "The existing dynamic group name in the existing identity domain for executing security functions."
}
variable "existing_id_domain_appdev_fun_dyn_group_name" {
  type    = string
  default = ""
  description = "The existing dynamic group name in the existing identity domain for executing applications functions."
}
variable "existing_id_domain_compute_agent_dyn_group_name" {
  type    = string
  default = ""
  description = "The existing dynamic group name in the existing identity domain for Compute agents."
}
variable "existing_id_domain_database_kms_dyn_group_name" {
  type    = string
  default = ""
  description = "The existing dynamic group name in the existing identity domain for accessing database encryption keys."
}
variable "existing_id_domain_net_fw_app_dyn_group_name" {
  type    = string
  default = ""
  description = "The existing dynamic group name in the existing identity domain for running network firewall appliances."
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
  description = "Whether to deploy new groups or use existing groups."
}
variable "rm_existing_iam_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which IAM management policies will be granted to."
}
variable "existing_iam_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which IAM management policies will be granted to."
}

variable "rm_existing_cred_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which credentials management policies will be granted to."
}
variable "existing_cred_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which credentials management policies will be granted to."
}

variable "rm_existing_security_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which security policies will be granted to."
}
variable "existing_security_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which security management policies will be granted to."
  }


variable "rm_existing_network_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which network management policies will be granted to."
}
variable "existing_network_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which network management policies will be granted to."
}

variable "rm_existing_appdev_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which application management policies will be granted to."
}
variable "existing_appdev_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which application management policies will be granted to."
}

variable "rm_existing_database_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which database management policies will be granted to."
  
}
variable "existing_database_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which database management policies will be granted to."
}

variable "rm_existing_auditor_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which auditor policies will be granted to."
}
variable "existing_auditor_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which auditing policies will be granted to."
}

variable "rm_existing_announcement_reader_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which announcement reader policies will be granted to."
}
variable "existing_announcement_reader_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which announcement reading policies will be granted to."
}

variable "rm_existing_exainfra_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which Exadata Cloud Service infrastructure management policies will be granted to."
}
variable "existing_exainfra_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which Exadata Cloud Service infrastructure management policies will be granted to."
}

variable "rm_existing_cost_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which cost management policies will be granted to."
  
}
variable "existing_cost_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which Cost management policies will be granted to."
}

variable "rm_existing_storage_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which storage management policies will be granted to."
}
variable "existing_storage_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which Storage management policies will be granted to."
}

variable "rm_existing_ag_admin_group_name" {
  type    = string
  default = ""
  description = "Only applicable to RMS deployments. The existing group to which access governance policies will be granted to."
}
variable "existing_ag_admin_group_name" {
  type        = list(string)
  default     = []
  description = "The existing group to which Access Governance management policies will be granted to."
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