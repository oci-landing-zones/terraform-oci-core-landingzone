# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ------------------------------------------------------
# ----- Security Zones
# ------------------------------------------------------
variable "enable_security_zones" {
  type        = bool
  default     = false
  description = "Determines if Security Zones are enabled in Landing Zone. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled."
}
variable "security_zones_reporting_region" {
  default     = ""
  type        = string
  description = "The reporting region of security zones. It defaults to tenancy home region if undefined."
}

variable "sz_security_policies" {
  type        = list(string)
  default     = []
  description = "Additional Security Zones Policy OCIDs to add to security zone recipe (The default policies are added based on CIS level). To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
  validation {
    condition     = length([for e in var.sz_security_policies : e if length(regexall("ocid1.securityzonessecuritypolicy.*", e)) > 0]) == length(var.sz_security_policies)
    error_message = "Validation failed for sz_security_policies must be a valid Security Zone Policy OCID.  To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
  }
}

# ------------------------------------------------------
# ----- Cloud Guard
# ------------------------------------------------------
variable "enable_cloud_guard" {
  type        = bool
  description = "Whether to enable Cloud Guard service and create a managed target at the Root compartment. The Landing Zone will enable Cloud Guard service and create a managed target at the Root compartment in case a target does not exist."
  default     = true
}
variable "customize_cloud_guard_settings" {
  type        = bool
  description = "Whether to customize Cloud Guard settings for a managed target. The Landing Zone enables Cloud Guard service and creates a managed target at the Root compartment in case a target at the Root compartment does not exist."
  default     = false
}
variable "enable_cloud_guard_cloned_recipes" {
  type        = bool
  description = "Whether cloned recipes are attached to the managed Cloud Guard target. If false, Oracle managed recipes are attached."
  default     = true
}
variable "cloud_guard_reporting_region" {
  description = "Cloud Guard reporting region, where Cloud Guard reporting resources are kept. If not set, it defaults to home region."
  type        = string
  default     = null
}
variable "cloud_guard_risk_level_threshold" {
  default     = "High"
  description = "Determines the minimum Risk level that triggers sending Cloud Guard problems to the defined Cloud Guard Email Endpoint. E.g. a setting of High will send notifications for Critical and High problems."
  validation {
    condition     = contains(["CRITICAL", "HIGH", "MEDIUM", "MINOR", "LOW"], upper(var.cloud_guard_risk_level_threshold))
    error_message = "Validation failed for cloud_guard_risk_level_threshold: valid values (case insensitive) are CRITICAL, HIGH, MEDIUM, MINOR, LOW."
  }
}
variable "cloud_guard_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for Cloud Guard related notifications."
  validation {
    condition     = length([for e in var.cloud_guard_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.cloud_guard_admin_email_endpoints)
    error_message = "Validation failed cloud_guard_admin_email_endpoints: invalid email address."
  }
}

# ------------------------------------------------------
# ----- Vulnerability Scanning Service
# ------------------------------------------------------
variable "vss_create" {
  description = "Whether Vulnerability Scanning Service recipes and targets are enabled in the Landing Zone."
  type        = bool
  default     = false
}
variable "vss_scan_schedule" {
  description = "The scan schedule for the Vulnerability Scanning Service recipe, if enabled. Valid values are WEEKLY or DAILY (case insensitive)."
  type        = string
  default     = "WEEKLY"
  validation {
    condition     = contains(["WEEKLY", "DAILY"], upper(var.vss_scan_schedule))
    error_message = "Validation failed for vss_scan_schedule: valid values are WEEKLY or DAILY (case insensitive)."
  }
}
variable "vss_scan_day" {
  description = "The week day for the Vulnerability Scanning Service recipe, if enabled. Only applies if vss_scan_schedule is WEEKLY (case insensitive)."
  type        = string
  default     = "SUNDAY"
  validation {
    condition     = contains(["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"], upper(var.vss_scan_day))
    error_message = "Validation failed for vss_scan_day: valid values are SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY (case insensitive)."
  }
}
variable "vss_port_scan_level" {
  description = "Valid values: STANDARD, LIGHT, NONE. STANDARD checks the 1000 most common port numbers, LIGHT checks the 100 most common port numbers, NONE does not check for open ports."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "LIGHT", "NONE"], upper(var.vss_port_scan_level))
    error_message = "Validation failed for vss_port_scan_level: valid values are STANDARD, LIGHT, NONE (case insensitive)."
  }
}
variable "vss_agent_scan_level" {
  description = "Valid values: STANDARD, NONE. STANDARD enables agent-based scanning. NONE disables agent-based scanning and moots any agent related attributes."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "NONE"], upper(var.vss_agent_scan_level))
    error_message = "Validation failed for vss_agent_scan_level: valid values are STANDARD, NONE (case insensitive)."
  }
}
variable "vss_agent_cis_benchmark_settings_scan_level" {
  description = "Valid values: STRICT, MEDIUM, LIGHT, NONE. STRICT: If more than 20% of the CIS benchmarks fail, then the target is assigned a risk level of Critical. MEDIUM: If more than 40% of the CIS benchmarks fail, then the target is assigned a risk level of High. LIGHT: If more than 80% of the CIS benchmarks fail, then the target is assigned a risk level of High. NONE: disables cis benchmark scanning."
  type        = string
  default     = "MEDIUM"
  validation {
    condition     = contains(["STRICT", "MEDIUM", "LIGHT", "NONE"], upper(var.vss_agent_cis_benchmark_settings_scan_level))
    error_message = "Validation failed for vss_agent_cis_benchmark_settings_scan_level: valid values are STRICT, MEDIUM, LIGHT, NONE (case insensitive)."
  }
}
variable "vss_enable_file_scan" {
  description = "Whether file scanning is enabled."
  type        = bool
  default     = false
}
variable "vss_folders_to_scan" {
  description = "A list of folders to scan. Only applies if vss_enable_file_scan is true. Currently, the Scanning service checks for vulnerabilities only in log4j and spring4shell."
  type        = list(string)
  default     = ["/"]
}

# ------------------------------------------------------
# ----- Bastion / Bastion Jump Host
# ------------------------------------------------------
variable "bastion_jump_host_instance_name" {
  type        = string
  default     = "bastion-jump-host-instance"
  description = "The display name of the bastion jump host instance."
}

variable "bastion_jump_host_ssh_public_key_path" {
  type        = string
  default     = null
  description = "The SSH public key to login to bastion jump host instance."
}

variable "bastion_jump_host_instance_shape" {
  type        = string
  default     = "VM.Standard.E4.Flex"
  description = "The instance shape for the bastion jump host instance."
}

variable "bastion_jump_host_boot_volume_size" {
  type        = number
  default     = 60
  description = "The boot volume size (in GB) for the bastion jump host instance."
}

variable "bastion_jump_host_flex_shape_memory" {
  type        = number
  default     = 56
  description = "The amount of memory (in GB) for the selected flex shape. Applicable to flexible shapes only."
}

variable "bastion_jump_host_flex_shape_cpu" {
  type        = number
  default     = 2
  description = "The number of OCPUs for the selected flex shape. Applicable to flexible shapes only."
}

variable "bastion_jump_host_custom_image_ocid" {
  type        = string
  default     = null
  description = "The custom image ocid of the user-provided bastion jump host instance. The custom image takes precedence over marketplace image."
}

variable "bastion_jump_host_marketplace_image_option" {
  type        = string
  default     = null
  description = "Options to select a jump host marketplace image. Either `Oracle Linux 8 STIG (Free)`, or `CIS Hardened Image Level 1 on Oracle Linux 8 (Paid)`."
}

variable "deploy_bastion_jump_host" {
  type        = bool
  default     = false
  description = "The option to deploy the bastion jump host."
}

variable "deploy_bastion_service" {
  type        = bool
  default     = false
  description = "The option to deploy the bastion service."
}

variable "bastion_service_name" {
  type        = string
  default     = null
  description = "The bastion service name."
}

variable "bastion_service_allowed_cidrs" {
  type        = list(string)
  default     = []
  description = "List of the bastion service allowed cidrs."
  validation {
    condition     = length([for c in var.bastion_service_allowed_cidrs : c if length(regexall("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", c)) > 0]) == length(var.bastion_service_allowed_cidrs)
    error_message = "Validation failed for bastion_service_allowed_cidrs: values must be in CIDR notation."
  }
}

variable "customize_bastion_service" {
  type        = bool
  default     = false
  description = "Set to true to set custom options for Bastion Service."
}

variable "customize_jump_host" {
  type        = bool
  default     = false
  description = "Set to true to set custom options for jump host."
}

variable "customize_jumphost_subnet" {
  type        = bool
  default     = false
  description = "Set to true to set custom options for jump host subnet."
}

# ------------------------------------------------------
# ----- Vault
# ------------------------------------------------------

variable "enable_vault" {
  type        = bool
  default     = false
  description = "Whether to enable vault service."
}
variable "vault_type" {
  type        = string
  default     = "DEFAULT"
  description = "The type of the vault. Options are 'DEFAULT' and 'VIRTUAL_PRIVATE'."
}

variable "vault_replica_region" {
  type        = string
  default     = null
  description = "The replica region where the vault backup is located. Only applicable when vault_type is VIRTUAL_PRIVATE."
}