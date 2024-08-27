# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "release" {
    value = var.display_output ? (fileexists("${path.module}/release.txt") ? file("${path.module}/release.txt") : "undefined") : null
}

output "region" {
    value = var.display_output ? var.region : null
}

output "cis_level" {
    value = var.display_output ? var.cis_level : null
}

output "service_label" {
    value = var.display_output ? var.service_label : null
}

output "compartments" {
    value = var.display_output && var.extend_landing_zone_to_new_region == false ? merge({for k, v in module.lz_compartments[0].compartments : k => {name:v.name, id:v.id}}, length(module.lz_top_compartment) > 0 ? {for k, v in module.lz_top_compartment[0].compartments : k => {name:v.name, id:v.id}} : {}) : null
}

output "vcns" {
    value = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? {for k, v in module.lz_network.provisioned_networking_resources.vcns : k => {name:v.display_name,id:v.id}} : null
}

output "subnets" {
    value = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? {for k, v in module.lz_network.provisioned_networking_resources.subnets : k => {name:v.display_name,id:v.id}} : null
}

output "network_security_groups" {
    value = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? {for k, v in module.lz_network.provisioned_networking_resources.network_security_groups : k => {name:v.display_name,id:v.id}} : null
}

output "dynamic_routing_gateways" {
    value = var.display_output && length(module.lz_network.provisioned_networking_resources) > 0 ? {for k, v in module.lz_network.provisioned_networking_resources.dynamic_routing_gateways : k => {name:v.display_name,id:v.id}} : null
}

output "nlb_private_ip_addresses" {
    value = var.display_output && length(module.lz_nlb) > 0 ? merge({for k, v in module.lz_nlb[0].nlbs_primary_private_ips : k => {id:v.id}},{for k, v in module.lz_nlb[0].nlbs_public_ips : k => {id:v.private_ip_id}}) : null
}