# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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