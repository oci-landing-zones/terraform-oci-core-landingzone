# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Security Lists and NSGs
#-------------------------------------------------------

variable "deploy_security_lists" {
  type        = bool
  description = "Whether to deploy security lists. Set to true to deploy security lists."
  default     = false
}

variable "deploy_nsgs" {
  type        = bool
  description = "Whether to deploy NSGs. Set to true to deploy NSGs."
  default     = true
}

variable "jumphost_cidrs" {
  type        = list(string)
  description = "List of jumphost CIDR blocks allowed to ssh to Workload VCN subnets."
  default     = []
  validation {
    condition     = length([for c in var.jumphost_cidrs : c if length(regexall("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", c)) > 0]) == length(var.jumphost_cidrs)
    error_message = "Validation failed for jumphost_cidrs: values must be in CIDR notation."
  }
}

variable "customize_names" {
  type        = bool
  description = "Whether to customize the default names of the security lists and NSGs. Set to true to customize names."
  default     = false
}

variable "app_nsg_name" {
  type        = string
  description = "Custom name of the APP (application) NSG"
  default     = null
}

variable "web_nsg_name" {
  type        = string
  description = "Custom name of the WEB NSG"
  default     = null
}

variable "db_nsg_name" {
  type        = string
  description = "Custom name of the DB (database) NSG"
  default     = null
}

variable "mgmt_nsg_name" {
  type        = string
  description = "Custom name of the MGMT (management) NSG"
  default     = null
}

variable "lb_nsg_name" {
  type        = string
  description = "Custom name of the LB (load balancer) NSG"
  default     = null
}

variable "db_backup_nsg_name" {
  type        = string
  description = "Custom name of the Database Backup NSG"
  default     = null
}

variable "spare_nsg_name" {
  type        = string
  description = "Custom name of the spare NSG"
  default     = ""
}

variable "app_subnet_seclist_name" {
  type        = string
  description = "Custom name of the APP (application) subnet security list"
  default     = null
}

variable "app_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Application subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "app_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Application subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "web_subnet_seclist_name" {
  type        = string
  description = "Custom name of the WEB subnet security list"
  default     = null
}

variable "web_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Web subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "web_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Web subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "db_subnet_seclist_name" {
  type        = string
  description = "Custom name of the DB (database) subnet security list"
  default     = null
}

variable "db_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Database subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "db_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Database subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "mgmt_subnet_seclist_name" {
  type        = string
  description = "Custom name of the MGMT (management) subnet security list"
  default     = null
}

variable "mgmt_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Management subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "mgmt_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Management subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "lb_subnet_seclist_name" {
  type        = string
  description = "Custom name of the LB (load balancer) subnet security list"
  default     = null
}

variable "lb_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Load Balancer subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "lb_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Load Balancer subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "db_backup_subnet_seclist_name" {
  type        = string
  description = "Custom name of the Database Backup subnet security list"
  default     = null
}

variable "db_backup_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the Database Backup subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "db_backup_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the Database Backup subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "spare_subnet_seclist_name" {
  type        = string
  description = "Custom name of the spare subnet security list"
  default     = ""
}

variable "spare_subnet_seclist_additional_ingress_rules" {
  description = "Optional additional ingress rules for the spare subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    src          = string,
    src_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "spare_subnet_seclist_additional_egress_rules" {
  description = "Optional additional egress rules for the spare subnet security list."
  type = list(object({
    stateless    = optional(bool),
    protocol     = string,
    description  = optional(string),
    dst          = string,
    dst_type     = string,
    src_port_min = optional(number),
    src_port_max = optional(number),
    dst_port_min = optional(number),
    dst_port_max = optional(number),
    icmp_type    = optional(number),
    icmp_code    = optional(number)
  }))
  default = []
}

variable "app_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for App subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "app_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for App subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}


variable "web_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for Web subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "web_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for Web subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}


variable "db_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for db subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "db_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for db subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}


variable "mgmt_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for the management subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "mgmt_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for the management subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}


variable "lb_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for the lb subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "lb_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for the lb subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}


variable "db_backup_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for the db backup subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "db_backup_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for the db backup subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "spare_nsg_additional_ingress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    src          = optional(string)
    src_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional ingress rules for the spare subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}

variable "spare_nsg_additional_egress_rules" {
  type = map(object({
    description  = optional(string),
    stateless    = optional(bool),
    protocol     = string
    dst          = string
    dst_type     = optional(string)
    icmp_type    = optional(number)
    icmp_code    = optional(number)
    dst_port_min = optional(number)
    dst_port_max = optional(number)
  }))

  description = "Additional egress rules for the spare subnet nsg. This allows for the injection of additional optional security rules."
  default     = {}
}
