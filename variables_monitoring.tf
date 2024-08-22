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
# ----- Service Connector Hub
# ------------------------------------------------------
variable "enable_service_connector" {
  description = "Whether Service Connector Hub should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in 'service_connector_target_kind'. The Service Connector resource is created in INACTIVE state. To activate, set 'activate_service_connector' to true (costs may incur)."
  type        = bool
  default     = false
}
variable "activate_service_connector" {
  description = "Whether Service Connector Hub should be activated. If true, costs my incur due to usage of Object Storage bucket, Streaming or Function."
  type        = bool
  default     = false
}
variable "service_connector_target_kind" {
  type        = string
  default     = "objectstorage"
  description = "Service Connector Hub target resource. Valid values are 'objectstorage', 'streaming', 'functions' or 'logginganalytics'. In case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream ocid in 'existing_service_connector_target_stream_id' and that stream is used. If no ocid is provided, a new stream is created. In case of 'functions', you must provide the existing function ocid in 'existing_service_connector_target_function_id'. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled if not already."
  validation {
    condition     = contains(["objectstorage", "streaming", "functions", "logginganalytics"], var.service_connector_target_kind)
    error_message = "Validation failed for service_connector_target_kind: valid values are objectstorage, streaming, functions or logginganalytics."
  }
}
variable "onboard_logging_analytics" {
  description = "Whether Logging Analytics will be enabled in the tenancy. If true, the Logging Analytics service will be enabled in the tenancy and a new Logging Analytics Namespace will be created. If false, the existing Logging Analytics namespace will be used. Only applicable if 'service_connector_target_kind' is set to 'logginganalytics'."
  type        = bool
  default     = false
}
variable "existing_service_connector_bucket_vault_compartment_id" {
  description = "The OCID of an existing compartment for the vault with the key used in Service Connector target Object Storage bucket encryption. Only applicable if 'service_connector_target_kind' is set to 'objectstorage'."
  type        = string
  default     = null
}
variable "existing_service_connector_bucket_vault_id" {
  description = "The OCID of an existing vault for the encryption key used in Service Connector target Object Storage bucket. Only applicable if 'service_connector_target_kind' is set to 'objectstorage'."
  type        = string
  default     = null
}
variable "existing_service_connector_bucket_key_id" {
  description = "The OCID of an existing encryption key used in Service Connector target Object Storage bucket. Only applicable if 'service_connector_target_kind' is set to 'objectstorage'."
  type        = string
  default     = null
}
variable "existing_service_connector_target_stream_id" {
  description = "The OCID of an existing stream to be used as the Service Connector target. Only applicable if 'service_connector_target_kind' is set to 'streaming'."
  type        = string
  default     = null
}
variable "existing_service_connector_target_function_id" {
  description = "The OCID of an existing function to be used as the Service Connector target. Only applicable if 'service_connector_target_kind' is set to 'functions'."
  type        = string
  default     = null
}