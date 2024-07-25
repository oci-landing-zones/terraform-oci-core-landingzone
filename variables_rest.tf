# ------------------------------------------------------
# ----- Events and Notifications
# ------------------------------------------------------
variable "network_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all network related notifications."
  validation {
    condition     = length(var.network_admin_email_endpoints) > 0
    error_message = "Validation failed for network_admin_email_endpoints: at least one valid email address must be provided."
  }
  validation {
    condition     = length([for e in var.network_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.network_admin_email_endpoints)
    error_message = "Validation failed for network_admin_email_endpoints: invalid email address."
  }
}
variable "security_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all security related notifications."
  validation {
    condition     = length(var.security_admin_email_endpoints) > 0
    error_message = "Validation failed for security_admin_email_endpoints: at least one valid email address must be provided."
  }
  validation {
    condition     = length([for e in var.security_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.security_admin_email_endpoints)
    error_message = "Validation failed for security_admin_email_endpoints: invalid email address."
  }
}
variable "storage_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all storage related notifications."
  validation {
    condition     = length([for e in var.storage_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.storage_admin_email_endpoints)
    error_message = "Validation failed for storage_admin_email_endpoints: invalid email address."
  }
}
variable "compute_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all compute related notifications."
  validation {
    condition     = length([for e in var.compute_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.compute_admin_email_endpoints)
    error_message = "Validation failed for compute_admin_email_endpoints: invalid email address."
  }
}
variable "budget_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all budget related notifications."
  validation {
    condition     = length([for e in var.budget_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.budget_admin_email_endpoints)
    error_message = "Validation failed for budget_admin_email_endpoints: invalid email address."
  }
}
variable "database_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all database related notifications."
  validation {
    condition     = length([for e in var.database_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.database_admin_email_endpoints)
    error_message = "Validation failed for database_admin_email_endpoints: invalid email address."
  }
}
variable "exainfra_admin_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for all Exadata infrastrcture related notifications. Only applicable if deploy_exainfra_cmp is true."
  validation {
    condition     = length([for e in var.exainfra_admin_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.exainfra_admin_email_endpoints)
    error_message = "Validation failed for exainfra_admin_email_endpoints: invalid email address."
  }
}
variable "create_alarms_as_enabled" {
  type        = bool
  default     = false
  description = "Creates alarm artifacts in disabled state when set to false"
}
variable "create_events_as_enabled" {
  type        = bool
  default     = false
  description = "Creates event rules artifacts in disabled state when set to false"
}
variable "alarm_message_format" {
  type        = string
  default     = "PRETTY_JSON"
  description = "Format of the message sent by Alarms"
  validation {
    condition     = contains(["PRETTY_JSON", "ONS_OPTIMIZED", "RAW"], upper(var.alarm_message_format))
    error_message = "Validation failed for alarm_message_format: valid values (case insensitive) are PRETTY_JSON, RAW, or ONS_OPTIMIZED."
  }
}
variable "notifications_advanced_options" {
  type    = bool
  default = false
}
# ------------------------------------------------------
# ----- Object Storage
# ------------------------------------------------------
variable "enable_oss_bucket" {
  description = "Whether an Object Storage bucket should be enabled. If true, the bucket is managed in the application (AppDev) compartment."
  type        = bool
  default     = true
}
variable "existing_bucket_vault_compartment_id" {
  description = "The OCID of an existing compartment for the vault with the key used in Object Storage bucket encryption."
  type        = string
  default     = null
}
variable "existing_bucket_vault_id" {
  description = "The OCID of an existing vault for the key used in Object Storage bucket encryption."
  type        = string
  default     = null
}
variable "existing_bucket_key_id" {
  description = "The OCID of an existing key used in Object Storage bucket encryption."
  type        = string
  default     = null
}
# ------------------------------------------------------
# ----- Cost Management - Budget
# ------------------------------------------------------
variable "budget_alert_threshold" {
  type        = number
  default     = 100
  description = "The threshold for triggering the alert expressed as a percentage. 100% is the default."
  validation {
    condition     = var.budget_alert_threshold > 0 && var.budget_alert_threshold < 10000
    error_message = "Validation failed for budget_alert_threshold: The threshold percentage should be greater than 0 and less than or equal to 10,000, with no leading zeros and a maximum of 2 decimal places."
  }
}
variable "budget_amount" {
  type        = number
  default     = 1000
  description = "The amount of the budget expressed as a whole number in the currency of the customer's rate card"
}
variable "create_budget" {
  type        = bool
  default     = false
  description = "Create a budget."
}
variable "budget_alert_email_endpoints" {
  type        = string
  default     = null
  description = "List of email addresses for all cost related notifications."
  validation {
    condition     = var.budget_alert_email_endpoints != null ? length([for e in split(",", var.budget_alert_email_endpoints) : e if length(regexall("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", trimspace(e))) > 0]) == length(split(",", var.budget_alert_email_endpoints)) : var.budget_alert_email_endpoints == null
    error_message = "Validation failed budget_alert_email_endpoints: invalid email address."
  }
}