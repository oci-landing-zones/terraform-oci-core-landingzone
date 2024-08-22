# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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
  type = list(string)
  default = []
  description =  "Additional Security Zones Policy OCIDs to add to security zone recipe (The default policies are added based on CIS level). To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
  validation {
    condition = length([for e in var.sz_security_policies : e if length(regexall("ocid1.securityzonessecuritypolicy.*", e)) > 0]) == length(var.sz_security_policies)
    error_message = "Validation failed for sz_security_policies must be a valid Security Zone Policy OCID.  To get a Security Zone policy OCID use the oci cli:  oci cloud-guard security-policy-collection list-security-policies --compartment-id <tenancy-ocid>."
  }
}

# ------------------------------------------------------
# ----- Cloud Guard
# ------------------------------------------------------
variable "enable_cloud_guard" {
  type        = bool
  description = "Determines whether the Cloud Guard service should be enabled. If true, Cloud Guard is enabled and the Root compartment is configured with a Cloud Guard target, as long as there is no pre-existing Cloud Guard target for the Root compartment (or target creation will fail). Keep in mind that once you set this to true, Cloud Guard target is managed by Landing Zone. If later on you switch this to false, the managed target is deleted and all (open, resolved and dismissed) problems associated with the deleted target are being moved to 'deleted' state. This operation happens in the background and would take some time to complete. Deleted problems can be viewed from the problems page using the 'deleted' status filter. For more details on Cloud Guard problems lifecycle, see https://docs.oracle.com/en-us/iaas/cloud-guard/using/problems-page.htm#problems-page__sect_prob_lifecycle. If Cloud Guard is already enabled and a target exists for the Root compartment, set this variable to false."
  default     = true
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
  description = "Valid values: STRICT, MEDIUM, LIGHTWEIGHT, NONE. STRICT: If more than 20% of the CIS benchmarks fail, then the target is assigned a risk level of Critical. MEDIUM: If more than 40% of the CIS benchmarks fail, then the target is assigned a risk level of High. LIGHTWEIGHT: If more than 80% of the CIS benchmarks fail, then the target is assigned a risk level of High. NONE: disables cis benchmark scanning."
  type        = string
  default     = "MEDIUM"
  validation {
    condition     = contains(["STRICT", "MEDIUM", "LIGHTWEIGHT", "NONE"], upper(var.vss_agent_cis_benchmark_settings_scan_level))
    error_message = "Validation failed for vss_agent_cis_benchmark_settings_scan_level: valid values are STRICT, MEDIUM, LIGHTWEIGHT, NONE (case insensitive)."
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