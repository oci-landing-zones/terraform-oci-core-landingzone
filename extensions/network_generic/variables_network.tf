# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- General
#-------------------------------------------------------

variable "tenancy_ocid" {
  default = ""
  description = "OCID of the tenancy."
}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key_password" {
  default = ""
}
variable "region" {
  description = "The region where resources are deployed."
  type        = string
}

# ------------------------------------------------------
# ----- Workload
#-------------------------------------------------------
variable "workload_name" {
  description = "Name of the workload. Default name is NetExt"
  validation {
    condition     = length(regexall("^[A-Za-z][A-Za-z0-9]", var.workload_name)) > 0
    error_message = "Validation failed for workload_name: value must contain alphanumeric characters only, starting with a letter."
  }
  default = "NetExt"
}

variable "isolated_resources" {
  description = "Set to true if the person deploying this network extension is in the Workload Admin group, and network resources are created inside the workload compartment. Set to false if the person deploying this network extension is in the Network Admin group, and network resources are created outside the workload compartment and in the central network compartment of a Landing Zone."
  type        = bool
  default     = false
}

variable "workload_compartment_ocid" {
  description = "OCID of the existing Workload Compartment."
  type        = string
  default     = null
}

variable "network_compartment_ocid" {
  description = "OCID of the existing Network Compartment."
  type        = string
  default     = null
}

variable "deploy_network_architecture" {
  description = "Options for deploying a network architecture. The 'Hub and Spoke' option will deploy the Workload VCN connected to an external main Hub network as a spoke. Selecting the 'Standalone' option will allow each workload VCN to manage their own internet and on-premises connectivity."
  type        = string
  default     = "Hub and Spoke"
}

# ------------------------------------------------------
# ----- Network
#-------------------------------------------------------

variable "hub_drg_ocid" {
  description = "OCID of the existing DRG."
  type        = string
  default     = null
}
variable "hub_vcn_cidrs" {
  description = "CIDR blocks of the Hub VCN."
  type        = list(string)
  default     = null
}

variable "onprem_cidrs" {
  description = "CIDR blocks of the on-premises connection(s)."
  type        = list(string)
  default     = null
}

variable "workload_vcn_cidr_block" {
  description = "CIDR block of the Workload VCN."
  type        = string
  default     = null
}

variable "customize_subnets" {
  description = "Whether to customize subnet values. Set to true to use custom values for the subnet CIDRs and names."
  type        = bool
  default     = false
}

variable "add_app_subnet" {
  description = "Whether to add an Application Subnet that contains the application-specific network resources."
  type        = bool
  default     = false
}

variable "app_subnet_name" {
  description = "Name of the Application Subnet."
  type        = string
  default     = null
}

variable "app_subnet_cidr" {
  description = "CIDR Block of the App Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "app_subnet_allow_public_access" {
  description = "Whether to allow public access to the Application Subnet."
  type        = bool
  default     = false
}

variable "app_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Application Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "app_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Application Subnet."
  type        = bool
  default     = false
}

variable "add_db_subnet" {
  description = "Whether to add an Database Subnet that contains the application-specific network resources."
  type        = bool
  default     = false
}

variable "db_subnet_name" {
  description = "Name of the Database Subnet."
  type        = string
  default     = null
}

variable "db_subnet_cidr" {
  description = "CIDR Block of the Database Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "db_subnet_allow_public_access" {
  description = "Whether to allow public access to the Application Subnet."
  type        = bool
  default     = false
}

variable "db_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Database Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "db_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Database Subnet."
  type        = bool
  default     = false
}

variable "add_lb_subnet" {
  description = "Whether to add a Load Balancer Subnet that contains the application-specific network resources."
  type        = bool
  default     = false
}

variable "lb_subnet_name" {
  description = "Name of the Load Balancer Subnet."
  type        = string
  default     = null
}

variable "lb_subnet_cidr" {
  description = "CIDR Block of the Load Balancer Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "lb_subnet_allow_public_access" {
  description = "Whether to allow public access to the Load Balancer Subnet."
  type        = bool
  default     = true
}

variable "lb_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Load Balancer Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "lb_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Load Balancer Subnet."
  type        = bool
  default     = false
}

variable "add_mgmt_subnet" {
  description = "Whether to add a Management Subnet that contains the application-specific network resources."
  type        = bool
  default     = false
}

variable "mgmt_subnet_name" {
  description = "Name of the Management Subnet."
  type        = string
  default     = null
}

variable "mgmt_subnet_cidr" {
  description = "CIDR Block of the Management Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "mgmt_subnet_allow_public_access" {
  description = "Whether to allow public access to the Management Subnet."
  type        = bool
  default     = false
}

variable "mgmt_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Load Balancer Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "mgmt_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Management Subnet."
  type        = bool
  default     = false
}

variable "add_web_subnet" {
  description = "Whether to add a Web Subnet that contains the application-specific network resources."
  type        = bool
  default     = false
}

variable "web_subnet_name" {
  description = "Name of the Web Subnet."
  type        = string
  default     = null
}

variable "web_subnet_cidr" {
  description = "CIDR Block of the Web Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "web_subnet_allow_public_access" {
  description = "Whether to allow public access to the Web Subnet."
  type        = bool
  default     = true
}

variable "web_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Web Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "web_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Web Subnet."
  type        = bool
  default     = false
}

variable "add_db_backup_subnet" {
  description = "Whether to add a Database Backup Subnet."
  type        = bool
  default     = false
}

variable "db_backup_subnet_name" {
  description = "Name of the Database Backup Subnet."
  type        = string
  default     = null
}

variable "db_backup_subnet_cidr" {
  description = "CIDR Block of the Database Backup Subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = null
}

variable "db_backup_subnet_allow_public_access" {
  description = "Whether to allow public access to the Database Backup Subnet."
  type        = bool
  default     = true
}

variable "db_backup_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the Database Backup Subnet."
  type        = bool
  default     = false
}

variable "db_backup_subnet_additional_route_rules" {
  description = "Optional additional route rules for the Database Backup Subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default = {}
}

variable "add_spare_subnet" {
  description = "Whether to add a customizable spare subnet."
  type        = bool
  default     = false
}

variable "spare_subnet_name" {
  description = "Name of the spare subnet."
  type        = string
  default     = ""
}

variable "spare_subnet_cidr" {
  description = "CIDR block of the spare subnet. It must be within the VCN CIDR block range."
  type        = string
  default     = ""
}

variable "spare_subnet_allow_public_access" {
  description = "Whether to allow public access to the spare subnet."
  type        = bool
  default     = false
}

variable "spare_subnet_allow_onprem_connectivity" {
  description = "Whether to allow on-premises connectivity to the spare subnet."
  type        = bool
  default     = false
}

variable "spare_subnet_additional_route_rules" {
  description = "Optional additional route rules for the spare subnet."
  type        = map(object({
    network_entity_id  = optional(string),
    network_entity_key = optional(string),
    description        = optional(string),
    destination        = string,
    destination_type   = string
  }))
  default     = {}
}

variable "enable_nat_gateway" {
  description = "Whether to enable a NAT gateway. Set to true to enable a NAT gateway."
  type        = bool
  default     = false
}

variable "enable_service_gateway" {
  description = "Whether to enable a Service gateway. Set to true to enable a Service gateway."
  type        = bool
  default     = false
}

variable "internet_gateway_display_name" {
  description = "Display name of the Internet Gateway. Default is internet-gateway."
  type        = string
  default     = "internet-gateway"
}

variable "nat_gateway_display_name" {
  description = "Display name of the NAT gateway. Default is nat-gateway."
  type        = string
  default     = "nat-gateway"
}

variable "nat_gateway_block_traffic" {
  description = "Whether to block traffic with the NAT gateway. Default is false."
  type        = bool
  default     = false
}

variable "service_gateway_display_name" {
  description = "Display name of the Service Gateway. Default is service-gateway."
  type        = string
  default     = "service-gateway"
}

variable "service_gateway_services" {
  description = "Services supported by Service Gateway. Values are 'objectstorage' and 'all-services'."
  type        = string
  default     = "all-services"

}
variable "additional_route_tables" {
  description = "Optional additional route tables."
  type        = map(object({
    compartment_id = optional(string),
    defined_tags   = optional(map(string)),
    freeform_tags  = optional(map(string)),
    display_name   = optional(string),
    route_rules = optional(map(object({
      network_entity_id  = optional(string),
      network_entity_key = optional(string),
      description        = optional(string),
      destination = optional(string),
      destination_type = optional(string) // Supported values: "CIDR_BLOCK", "SERVICE_CIDR_BLOCK" - only for SGW
    })))
  }))
  default = {}
}
