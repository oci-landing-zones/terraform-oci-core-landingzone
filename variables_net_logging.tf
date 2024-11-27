# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Logging Variables
#-------------------------------------------------------

#Firewall Threat Log

variable "firewall_threat_log_name" {
  type        = string
  description = "Firewall Threat Log"
  default     = "CORE-LZ-OCI-NATIVE-NFW-THREAT-LOG"
}
variable "firewall_threat_log_type" {
  type        = string
  description = "Firewall Threat Log Type"
  default     = "SERVICE"
}
variable "firewall_threat_log_category" {
  type        = string
  description = "Firewall Threat Log Category"
  default     = "threatlog"
}
variable "firewall_threat_log_service" {
  type        = string
  description = "Firewall Threat Log Service Type"
  default     = "ocinetworkfirewall"
}

#Firewall Traffic Log

variable "firewall_traffic_log_name" {
  type        = string
  description = "Firewall Traffic Log"
  default     = "CORE-LZ-OCI-NATIVE-NFW-TRAFFIC-LOG"
}
variable "firewall_traffic_log_type" {
  type        = string
  description = "Firewall Traffic Log Type"
  default     = "SERVICE"
}
variable "firewall_traffic_log_category" {
  type        = string
  description = "Firewall Traffic Log Category"
  default     = "trafficlog"
}
variable "firewall_traffic_log_service" {
  type        = string
  description = "Firewall Traffic Log Service Type"
  default     = "ocinetworkfirewall"
}