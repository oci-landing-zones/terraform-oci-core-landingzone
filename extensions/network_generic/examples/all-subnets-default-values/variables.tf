
# Provider (credential) variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "region" {}

# Deployment details
variable "isolated_resources" {}
variable "workload_compartment_ocid" {}
variable "deploy_network_architecture" {}
variable "workload_vcn_cidr_block" {}
variable "hub_vcn_cidrs" {}
variable "hub_drg_ocid" {}
variable "add_app_subnet" {}
variable "add_db_subnet" {}
variable "add_lb_subnet" {}
variable "add_mgmt_subnet" {}
variable "add_web_subnet" {}
variable "add_db_backup_subnet" {}

