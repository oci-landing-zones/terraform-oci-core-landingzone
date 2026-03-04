# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {

  add_oke_vcn2 = var.define_net == true && var.add_oke_vcn2 == true

  oke_vcn2_display_name                 = coalesce(var.oke_vcn2_name, "${var.service_label}-oke-vcn-2")
  oke_vcn2_api_subnet_display_name      = coalesce(var.oke_vcn2_api_subnet_name, "${var.service_label}-oke-vcn-2-api-subnet")
  oke_vcn2_api_subnet_cidr              = coalesce(var.oke_vcn2_api_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 0))
  oke_vcn2_workers_subnet_display_name  = coalesce(var.oke_vcn2_workers_subnet_name, "${var.service_label}-oke-vcn-2-workers-subnet")
  oke_vcn2_workers_subnet_cidr          = coalesce(var.oke_vcn2_workers_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 1))
  oke_vcn2_services_subnet_display_name = coalesce(var.oke_vcn2_services_subnet_name, "${var.service_label}-oke-vcn-2-services-subnet")
  oke_vcn2_services_subnet_cidr         = coalesce(var.oke_vcn2_services_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 8, 2))
  oke_vcn2_mgmt_subnet_display_name     = coalesce(var.oke_vcn2_mgmt_subnet_name, "${var.service_label}-oke-vcn-2-mgmt-subnet")
  oke_vcn2_mgmt_subnet_cidr             = coalesce(var.oke_vcn2_mgmt_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 12, 48))
  oke_vcn2_pods_subnet_display_name     = coalesce(var.oke_vcn2_pods_subnet_name, "${var.service_label}-oke-vcn-2-pods-subnet")
  oke_vcn2_pods_subnet_cidr             = coalesce(var.oke_vcn2_pods_subnet_cidr, cidrsubnet(var.oke_vcn2_cidrs[0], 3, 1))

  ## This variable defines the allowed CIDR and port combinations for ingress into the OKE-VCN-2 services tier subnet when the subnet is public.  
  oke_vcn2_external_allowed_cidrs_to_ports_into_services_tier = local.add_oke_vcn2 == true ? flatten([for cidr in var.oke_vcn2_external_allowed_cidrs_into_services_tier : [for port in var.oke_vcn2_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}" ]]) : []
  
  oke_vcn_2 = local.add_oke_vcn2 == true ? {
    "OKE-VCN-2" = {
      display_name                     = local. oke_vcn2_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.oke_vcn2_cidrs,
      dns_label                        = substr(replace(coalesce(var.oke_vcn2_name, "oke-vcn-2"), "/[^\\w]/", ""), 0, 14)
      block_nat_traffic                = false

      subnets = merge(
        {
          "OKE-VCN-2-API-SUBNET" = {
            cidr_block                = local.oke_vcn2_api_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn2_api_subnet_display_name
            dns_label                 = substr(replace(coalesce(var.oke_vcn2_api_subnet_name, "api-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-2-API-SUBNET-ROUTE-TABLE"
          }
        },
        {
          "OKE-VCN-2-WORKERS-SUBNET" = {
            cidr_block                = local.oke_vcn2_workers_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn2_workers_subnet_display_name
            dns_label                 = substr(replace(coalesce(var.oke_vcn2_workers_subnet_name, "workers-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-2-WORKERS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-2-WORKERS-SUBNET-SL"]
          }
        },
        {
          "OKE-VCN-2-SERVICES-SUBNET" = {
            cidr_block                = local.oke_vcn2_services_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn2_services_subnet_display_name
            dns_label                 = substr(replace(coalesce(var.oke_vcn2_services_subnet_name, "services-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = var.oke_vcn2_services_subnet_is_private
            route_table_key           = "OKE-VCN-2-SERVICES-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-2-SERVICES-SUBNET-SL"]
          }
        },
        var.add_oke_vcn2_mgmt_subnet ? {
          "OKE-VCN-2-MGMT-SUBNET" = {
            cidr_block                = local.oke_vcn2_mgmt_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn2_mgmt_subnet_display_name
            dns_label                 = substr(replace(coalesce(var.oke_vcn2_mgmt_subnet_name, "mgmt-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-2-MGMT-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-2-MGMT-SUBNET-SL"]
          }
        } : {},
        upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
          "OKE-VCN-2-PODS-SUBNET" = {
            cidr_block                = local.oke_vcn2_pods_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.oke_vcn2_pods_subnet_display_name
            dns_label                 = substr(replace(coalesce(var.oke_vcn2_pods_subnet_name, "pods-subnet"), "/[^\\w]/", ""), 0, 14)
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "OKE-VCN-2-PODS-SUBNET-ROUTE-TABLE"
            security_list_keys        = ["OKE-VCN-2-PODS-SUBNET-SL"]
          }
        } : {}
      )

      route_tables = merge({
        "OKE-VCN-2-API-SUBNET-ROUTE-TABLE" = {
          display_name = "api-subnet-route-table"
          route_rules = merge(
            local.hub_with_vcn == false ? {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },
              "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
              }
            } : {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },  
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        =  "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          )
        }
        },
        {
          "OKE-VCN-2-WORKERS-SUBNET-ROUTE-TABLE" = {
            display_name = "workers-subnet-route-table"
            route_rules = merge(
            local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {  
                "NATGW-RULE" = {
                   network_entity_key = "OKE-VCN-2-NAT-GATEWAY"
                   description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                   destination        = "0.0.0.0/0"
                   destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn_2_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
            ) : {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },  
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        =  "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
          )
          }
        },
        {
          "OKE-VCN-2-SERVICES-SUBNET-ROUTE-TABLE" = {
            display_name = "services-subnet-route-table"
            route_rules = local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "INTERNET-RULE" = {
                  network_entity_key = var.oke_vcn2_services_subnet_is_private == false ? "OKE-VCN-2-INTERNET-GATEWAY" : "OKE-VCN-2-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the ${var.oke_vcn2_services_subnet_is_private == false ? "Internet" : "NAT"} Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },
              {  
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                  description        = "Traffic destined for ${var.oke_vcn2_services_subnet_is_private == false ? "OCI Object Storage service" : "all OCI services"} in Oracle Services Network is routed through the Service Gateway."
                  destination        = var.oke_vcn2_services_subnet_is_private == false ? "objectstorage" : "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              local.oke_vcn_2_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.  
             ) : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG" # Case when there is a Hub VCN. All traffic is routed through the DRG.
                description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              },
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          }
        },
        var.add_oke_vcn2_mgmt_subnet ? {
          "OKE-VCN-2-MGMT-SUBNET-ROUTE-TABLE" = {
            display_name = "mgmt-subnet-route-table"
            route_rules = local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {  
                "NATGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-NAT-GATEWAY"
                  description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                  destination        = "0.0.0.0/0"
                  destination_type   = "CIDR_BLOCK"
                }
              },  
              local.oke_vcn_2_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
             ) : {
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              }
            }
          }
        } : {},
        upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
          "OKE-VCN-2-PODS-SUBNET-ROUTE-TABLE" = {
            display_name = "pods-subnet-route-table"
            route_rules = merge(
              local.hub_with_vcn == false ? merge( # Case when there is no Hub VCN. The routes use VCN own gateways, but there can be cross VCN and on-prem connectivity through the DRG.
              {
                "SGW-RULE" = {
                  network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              {  
                "NATGW-RULE" = {
                   network_entity_key = "OKE-VCN-2-NAT-GATEWAY"
                   description        = "Traffic destined for networks outside the VCN is routed through the NAT Gateway."
                   destination        = "0.0.0.0/0"
                   destination_type   = "CIDR_BLOCK"
                }
              },
              local.oke_vcn_2_drg_routing # There can be cross VCN and on-prem connectivity through the DRG.
            ) : {
              "SGW-RULE" = {
                network_entity_key = "OKE-VCN-2-SERVICE-GATEWAY"
                description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                destination        = "all-services"
                destination_type   = "SERVICE_CIDR_BLOCK"
              },  
              "HUB-DRG-RULE" = {
                network_entity_key = "HUB-DRG"
                description        =  "Traffic destined for networks outside the VCN is routed through the DRG."
                destination        = "0.0.0.0/0"
                destination_type   = "CIDR_BLOCK"
              }
            }
            )
          }
        } : {}
      )

      security_lists = merge(
        {
          "OKE-VCN-2-WORKERS-SUBNET-SL" = {
            display_name = "${local.oke_vcn2_workers_subnet_display_name}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Allows inbound ICMP traffic for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        },
        {
          "OKE-VCN-2-SERVICES-SUBNET-SL" = {
            display_name = "${local.oke_vcn2_services_subnet_display_name}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Ingress ICMP for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        },
        var.add_oke_vcn2_mgmt_subnet ? {
          "OKE-VCN-2-MGMT-SUBNET-SL" = {
            display_name = "${local.oke_vcn2_mgmt_subnet_display_name}-security-list"
            ingress_rules = [
              {
                description = "Allows inbound ICMP traffic for path discovery."
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              },
              {
                description  = "Allows inbound SSH access from hosts in the mgmt subnet. Required for OCI Bastion service endpoints in the mgmt subnet to reach Operator host in the mgmt subnet."
                stateless    = false
                protocol     = "TCP"
                src          = local.oke_vcn2_mgmt_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
            egress_rules = [
              {
                description  = "Allows outbound SSH traffic from MGMT subnet to hosts in the MGMT subnet, for Bastion service."
                stateless    = false
                protocol     = "TCP"
                dst          = local.oke_vcn2_mgmt_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              },
              {
                description  = "Egress for bastion service to API endpoint"
                stateless    = false
                protocol     = "TCP"
                dst          = local.oke_vcn2_api_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 6443
                dst_port_max = 6443
              },
              {
                description  = "Egress for bastion service to worker nodes"
                stateless    = false
                protocol     = "TCP"
                dst          = local.oke_vcn2_workers_subnet_cidr
                dst_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            ]
          }
        } : {},
        upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
          "OKE-VCN-2-PODS-SUBNET-SL" = {
            display_name = "${local.oke_vcn2_pods_subnet_display_name}-security-list"
            egress_rules = []
            ingress_rules = [
              {
                description = "Ingress ICMP for path discovery"
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
          }
        } : {}
      )

      network_security_groups = merge(
        {
          "OKE-VCN-2-API-NSG" = {
            display_name = "api-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-SERVICES-API-RULE" = {
                  description = "Allows TCP egress from OKE control plane to OCI services"
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
              },
              {
                "EGRESS-TO-KUBELET-API-RULE" = {
                  description  = "Allows TCP egress from OKE control plane to Kubelet on worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
              },
              {
                "EGRESS-TO-WORKERS-API-RULE" = {
                  description  = "Allows TCP egress from OKE control plane to worker node"
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              },
              {
                "EGRESS-TO-WORKERS-ICMP-API-RULE" = {
                  description = "Allows outbound ICMP to worker nodes path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "OKE-VCN-2-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
              },
              upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "EGRESS-TO-API-API-RULE" = {
                  description  = "Allows TCP egress for Kubernetes control plane inter-communication"
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-PODS-API-RULE" = {
                  description = "Allows Kubernetes API endpoint to communicate with pods."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-2-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {}
            )
            ingress_rules = merge(
              {
                "INGRESS-FROM-WORKERS-6443-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              },
              {
                "INGRESS-FROM-WORKERS-10250-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
              },
              {
                "INGRESS-FROM-WORKERS-12250-API-RULE" = {
                  description  = "Allows inbound TCP from worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-WORKERS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              },
              upper(var.oke_vcn2_cni_type) == "FLANNEL" && var.add_oke_vcn2_mgmt_subnet ? {
                "INGRESS-FROM-MGMT-API-RULE" = {
                  description  = "Allows inbound TCP from mgmt subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.oke_vcn2_mgmt_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                } : upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-API-API-RULE" = {
                  description  = "Allows TCP ingress for Kubernetes control plane inter-communication."
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-API-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-BASTION-API-RULE" = {
                  description  = "Bastion service access to Kubernetes API endpoint"
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.oke_vcn2_mgmt_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-WORKERS-ICMP-API-RULE" = {
                  description = "Allows ICMP ingress for path discovery from worker nodes."
                  stateless   = false
                  protocol    = "ICMP"
                  src         = "OKE-VCN-2-WORKERS-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "INGRESS-FROM-PODS-6443-API-RULE" = {
                  description  = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "INGRESS-FROM-PODS-12250-API-RULE" = {
                  description  = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-PODS-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
              } : {},
              upper(var.oke_vcn2_cni_type) == "NATIVE" && var.add_oke_vcn2_mgmt_subnet ? {
                "INGRESS-FROM-OPERATOR-API-RULE" = {
                  description  = "Operator access to Kubernetes API endpoint"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
              } : {}
            )
          }
        },
        {  
          "OKE-VCN-2-WORKERS-NSG" = {
            display_name = "workers-nsg"
            egress_rules = merge(
              {
                "EGRESS-TO-WORKERS-WORKERS-RULE" = {
                  description = "Allows outbound access to worker nodes."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-2-WORKERS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
                "EGRESS-TO-SERVICES-WORKERS-RULE" = {
                  description = "Allows outbound TCP egress to OCI Services."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                }
                "EGRESS-TO-API-WORKERS-RULE" = {
                  description  = "Allows outbound TCP to OKE API endpoint."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-CONTROL-PLANE-10250-WORKERS-RULE" = {
                  description  = "Allows outbound TCP to OKE control plane health check."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 10250
                  dst_port_max = 10250
                }
                "EGRESS-TO-CONTROL-PLANE-12250-WORKERS-RULE" = {
                  description  = "Allows outbound TCP egress to OKE control plane."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 12250
                  dst_port_max = 12250
                }
                "EGRESS-TO-ANYWHERE-ICMP-WORKERS-RULE" = {
                  description = "Allows outbound ICMP for path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "EGRESS-TO-ANYWHERE-TCP-WORKERS-RULE" = {
                  description = "(optional) Allows worker nodes to communicate with the Internet."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "0.0.0.0/0"
                  dst_type    = "CIDR_BLOCK"
                }
              },
              upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "EGRESS-TO-PODS-WORKERS-RULE" = {
                  description = "Allows worker nodes to access pods."
                  stateless   = false
                  protocol    = "ALL"
                  dst         = "OKE-VCN-2-PODS-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                }
              } : {},
              local.oke_vcn_2_to_workers_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_pods_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_services_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_client_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_web_subnet_cross_vcn_egress
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-ALL-WORKERS-RULE" = {
                description = "Allows all inbound traffic from worker nodes."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-2-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-WORKERS-RULE" = {
                description = "Allows all inbound traffic from OKE control plane for webhooks served by workers."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-2-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-LB-10256-WORKERS-RULE" = {
                description  = "Allows inbound TCP for health check from public load balancers."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-2-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "INGRESS-FROM-LB-TCP-WORKERS-RULE" = {
                description  = "Allows inbound TCP from public load balancers."
                stateless    = false
                protocol     = "TCP"
                src          = "OKE-VCN-2-SERVICES-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              },
              upper(var.oke_vcn2_cni_type) == "FLANNEL" && var.add_oke_vcn2_mgmt_subnet ? {
                "INGRESS-FROM-MGMT-WORKERS-RULE" = {
                  description  = "Allows inbound SSH access from mgmt subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.oke_vcn2_mgmt_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
                } : upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "INGRESS-FROM-ANYWHERE-ICMP-WORKERS-RULE" = {
                  description = "Allows ICMP ingress to workers for path discovery."
                  stateless   = false
                  protocol    = "ICMP"
                  src         = "0.0.0.0/0"
                  src_type    = "CIDR_BLOCK"
                  icmp_type   = 3
                  icmp_code   = 4
                }
                "INGRESS-FROM-BASTION-WORKERS-RULE" = {
                  description  = "Bastion service ssh access to workers"
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.oke_vcn2_mgmt_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              upper(var.oke_vcn2_cni_type) == "NATIVE" && var.add_oke_vcn2_mgmt_subnet ? {
                "INGRESS-FROM-OPERATOR-WORKERS-RULE" = {
                  description  = "Operator ssh access to workers"
                  stateless    = false
                  protocol     = "TCP"
                  src          = "OKE-VCN-2-MGMT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              (local.hub_with_vcn == true && var.deploy_bastion_jump_host == true) ? {
                "INGRESS-FROM-HUB-JUMPHOST-SUBNET-RULE" = {
                  description  = "Ingress from Hub VCN Jumphost Subnet. Required for inbound connections from jump hosts."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.hub_vcn_jumphost_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.oke_vcn_2_to_workers_subnet_cross_vcn_ingress
            )
          }
        },
        {  
          "OKE-VCN-2-SERVICES-NSG" = {
            display_name = "services-nsg"
            egress_rules = merge({
              "EGRESS-TO-WORKERS-NSG-RULE" = {
                description  = "Allows outbound TCP to workers nodes for NodePort traffic."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-2-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 30000
                dst_port_max = 32767
              }
              "EGRESS-TO-WORKERS-TCP-RULE" = {
                description  = "Allows outbound TCP egress to worker nodes for health checks."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-2-WORKERS-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 10256
                dst_port_max = 10256
              }
              "EGRESS-TO-WORKERS-ICMP-RULE" = {
                description = "Allows outbound ICMP to worker nodes for path discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "OKE-VCN-2-WORKERS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
                icmp_type   = 3
                icmp_code   = 4
              }
            }),
            ingress_rules = { for cidr_port_pair in local.oke_vcn2_external_allowed_cidrs_to_ports_into_services_tier : "INGRESS-FROM-${split(",",cidr_port_pair)[0]}-ON-${split(",",cidr_port_pair)[1]}-RULE" => {
              description  = "Ingress from ${split(",",cidr_port_pair)[0]} over ${split(":",split(",",cidr_port_pair)[1])[0]} on port ${split(":",split(",",cidr_port_pair)[1])[1]}."
              stateless    = false
              protocol     = split(":",split(",",cidr_port_pair)[1])[0]
              src          = split(",",cidr_port_pair)[0]
              src_type     = "CIDR_BLOCK"
              dst_port_min = split(":",split(",",cidr_port_pair)[1])[1] == "ALL" ? null : split(":",split(",",cidr_port_pair)[1])[1]
              dst_port_max = split(":",split(",",cidr_port_pair)[1])[1] == "ALL" ? null : split(":",split(",",cidr_port_pair)[1])[1]
            }}
          }
        },  
        var.add_oke_vcn2_mgmt_subnet ? {
          "OKE-VCN-2-MGMT-NSG" = {
            display_name = "mgmt-nsg"
            egress_rules = merge({
              "EGRESS-TO-SERVICE-GATEWAY-RULE" = {
                description = "Allows outbound TCP to OCI services."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-ANYWHERE-RULE" = {
                description = "Allows outbound connections to anywhere."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
              },
              upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
                "EGRESS-TO-API-RULE" = {
                  description  = "Allows TCP outbound traffic from mgmt subnet to Kubernetes API server, for OKE management."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-API-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6443
                  dst_port_max = 6443
                }
                "EGRESS-TO-WORKERS-RULE" = {
                  description  = "Allows outbound SSH to worker nodes."
                  stateless    = false
                  protocol     = "TCP"
                  dst          = "OKE-VCN-2-WORKERS-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {}
            )
            ingress_rules = upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
              "INGRESS-FROM-SSH-RULE" = {
                description  = "Allows inbound SSH access."
                stateless    = false
                protocol     = "TCP"
                src          = local.oke_vcn2_mgmt_subnet_cidr
                src_type     = "CIDR_BLOCK"
                dst_port_min = 22
                dst_port_max = 22
              }
            } : {}
          }
        } : {},
        upper(var.oke_vcn2_cni_type) == "NATIVE" ? {
          "OKE-VCN-2-PODS-NSG" = {
            display_name = "pods-nsg"
            egress_rules = merge({
              "EGRESS-TO-PODS-RULE" = {
                description = "Allows pods to communicate with other pods."
                stateless   = false
                protocol    = "ALL"
                dst         = "OKE-VCN-2-PODS-NSG"
                dst_type    = "NETWORK_SECURITY_GROUP"
              }
              "EGRESS-TO-ICMP-RULE" = {
                description = "Path Discovery."
                stateless   = false
                protocol    = "ICMP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
              "EGRESS-TO-SERVICES-TCP-RULE" = {
                description = "Allows TCP egress from pods to OCI Services."
                stateless   = false
                protocol    = "TCP"
                dst         = "all-services"
                dst_type    = "SERVICE_CIDR_BLOCK"
              }
              "EGRESS-TO-INTERNET-RULE" = {
                description = "(optional) Allows pods nodes to communicate with internet."
                stateless   = false
                protocol    = "TCP"
                dst         = "0.0.0.0/0"
                dst_type    = "CIDR_BLOCK"
              }
              "EGRESS-TO-API-RULE" = {
                description  = "Allows TCP egress from pods to Kubernetes API server."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-2-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 6443
                dst_port_max = 6443
              }
              "EGRESS-TO-API-12250-RULE" = {
                description  = "Allows TCP egress from pods to OKE control plane."
                stateless    = false
                protocol     = "TCP"
                dst          = "OKE-VCN-2-API-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = 12250
                dst_port_max = 12250
              }
              },
              local.oke_vcn_2_to_services_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_pods_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_workers_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_client_subnet_cross_vcn_egress,
              local.oke_vcn_2_to_web_subnet_cross_vcn_egress
            )
            ingress_rules = merge({
              "INGRESS-FROM-WORKERS-RULE" = {
                description = "Allows worker nodes to access pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-2-WORKERS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-FROM-API-RULE" = {
                description = "Allows Kubernetes API endpoint to communicate with pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-2-API-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              "INGRESS-TO-PODS-RULE" = {
                description = "Allows pods to communicate with other pods."
                stateless   = false
                protocol    = "ALL"
                src         = "OKE-VCN-2-PODS-NSG"
                src_type    = "NETWORK_SECURITY_GROUP"
              }
              },
              local.oke_vcn_2_to_pods_subnet_cross_vcn_ingress
            )
          }
        } : {}
      )

      vcn_specific_gateways = merge(
        {
          service_gateways = {
            "OKE-VCN-2-SERVICE-GATEWAY" = {
              display_name = "Service Gateway"
              services     = "all-services"
            }
          }
        },  
        local.hub_with_vcn == false ? {
          internet_gateways = {
            "OKE-VCN-2-INTERNET-GATEWAY" = {
              enabled      = true
              display_name = "Internet Gateway"
            }
          }
          nat_gateways = {
            "OKE-VCN-2-NAT-GATEWAY" = {
              block_traffic = false
              display_name  = "NAT Gateway"
            }
          }
        } : {}
      )
    }
  } : {}

  ## Cross VCN Egress Rules from OKE_VCN_2
  ### Cross VCN egress rules to other OKE VCNs' Workers subnet
  oke_vcn_2_to_workers_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "EGRESS-TO-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${local.oke_vcn1_workers_subnet_display_name}."
        stateless    = false
        protocol     = "TCP"
        dst          = local.oke_vcn1_workers_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "EGRESS-TO-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Egress to ${local.oke_vcn3_workers_subnet_display_name}."
        stateless    = false
        protocol     = "TCP"
        dst          = local.oke_vcn3_workers_subnet_cidr
        dst_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {}
  )

  ### Cross VCN egress rules to other OKE VCNs' Services subnet
  oke_vcn_2_to_services_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? { for port in var.oke_vcn1_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN1-ON-${port}-RULE" => {
      description  = "Egress to ${local.oke_vcn1_services_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.oke_vcn1_services_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? { for port in var.oke_vcn3_services_ingress_destination_ports : "EGRESS-TO-OKE-VCN3-ON-${port}-RULE" => {
     description  = "Egress to ${local.oke_vcn3_services_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.oke_vcn3_services_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {}
  )

  ### Cross VCN egress rules to other OKE VCNs' Pods subnet
  oke_vcn_2_to_pods_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) && (upper(var.oke_vcn1_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "EGRESS-TO-OKE-VCN-1-PODS-SUBNET-RULE" = {
        description = "Egress to ${local.oke_vcn1_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        dst         = local.oke_vcn1_pods_subnet_cidr
        dst_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) && (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "EGRESS-TO-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description = "Egress to ${local.oke_vcn3_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        dst         = local.oke_vcn3_pods_subnet_cidr
        dst_type    = "CIDR_BLOCK"
      }
    } : {}
  )

  ### Cross VCN egress rules to Exa VCNs' Client subnet
  oke_vcn_2_to_client_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_exa_vcn1 == true && var.exa_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-1")))) ? { for port in var.exa_vcn1_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN1-ON-${port}-RULE" => {
      description  = "Egress to ${local.exa_vcn1_client_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.exa_vcn1_client_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_exa_vcn2 == true && var.exa_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2")))) ? { for port in var.exa_vcn2_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN2-ON-${port}-RULE" => {
      description  = "Egress to ${local.exa_vcn2_client_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.exa_vcn2_client_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_exa_vcn3 == true && var.exa_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-3")))) ? { for port in var.exa_vcn3_client_ingress_destination_ports : "EGRESS-TO-EXA-VCN3-ON-${port}-RULE" => {
      description  = "Egress to ${local.exa_vcn3_client_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.exa_vcn3_client_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {}
  )

  ### Cross VCN egress rules to Three-tier VCNs'Web subnet
  oke_vcn_2_to_web_subnet_cross_vcn_egress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")))) ? { for port in var.tt_vcn1_web_ingress_destination_ports : "EGRESS-TO-TT-VCN1-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn1_web_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn1_web_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-2")))) ? { for port in var.tt_vcn2_web_ingress_destination_ports : "EGRESS-TO-TT-VCN2-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn2_web_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn2_web_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-3")))) ? { for port in var.tt_vcn3_web_ingress_destination_ports : "EGRESS-TO-TT-VCN3-ON-${port}-RULE" => {
      description  = "Egress to ${local.tt_vcn3_web_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      dst          = local.tt_vcn3_web_subnet_cidr
      dst_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {}
  )

  ## Ingress rules
  ### Cross VCN ingress rules to OKE-VCN-2 Services subnet
  oke_vcn_2_to_services_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN1-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn1_workers_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-OKE-VCN3-ON-${port}-RULE" => {
      description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.oke_vcn3_workers_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn1 == true && var.tt_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1")))) ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN1-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn1_app_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn1_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn2 == true && var.tt_vcn2_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-2")))) ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN2-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn2_app_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn2_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_tt_vcn3 == true && var.tt_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-3")))) ? { for port in var.oke_vcn2_services_ingress_destination_ports : "INGRESS-FROM-TT-VCN3-ON-${port}-RULE" => {
      description  = "Ingress from ${local.tt_vcn3_app_subnet_display_name} over ${split(":",port)[0]} on port ${split(":",port)[1]}."
      stateless    = false
      protocol     = split(":",port)[0]
      src          = local.tt_vcn3_app_subnet_cidr
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",port)[1]
      dst_port_max = split(":",port)[1]
    }} : {},
    ## Ingress from on-premises CIDRs
    (local.add_oke_vcn2 == true && (var.oke_vcn2_attach_to_drg == true && var.oke_vcn2_onprem_route_enable)) &&
    (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? { for cidr_port_pair in flatten([for cidr in var.allowed_onprem_cidrs_to_app_endpoints : [for port in var.oke_vcn2_services_ingress_destination_ports : "${trimspace(cidr)},${trimspace(port)}" ]]) : "INGRESS-FROM-${split(",",cidr_port_pair)[0]}-ON-${split(",",cidr_port_pair)[1]}-RULE" => {
      description  = "Ingress from onprem ${split(",",cidr_port_pair)[0]} over ${split(":",split(",",cidr_port_pair)[1])[0]} on port ${split(":",split(",",cidr_port_pair)[1])[1]}."
      stateless    = false
      protocol     = split(":",split(",",cidr_port_pair)[1])[0]
      src          = split(",",cidr_port_pair)[0]
      src_type     = "CIDR_BLOCK"
      dst_port_min = split(":",split(",",cidr_port_pair)[1])[1]
      dst_port_max = split(":",split(",",cidr_port_pair)[1])[1]
    }} : {}
  )

  ### Cross VCN ingress rules to OKE-VCN-2 Workers subnet
  oke_vcn_2_to_workers_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${local.oke_vcn1_workers_subnet_display_name}."
        stateless    = false
        protocol     = "TCP"
        src          = local.oke_vcn1_workers_subnet_cidr
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (upper(var.oke_vcn1_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn1_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn1_pods_subnet_cidr
        src_type    = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description  = "Ingress from ${local.oke_vcn3_workers_subnet_display_name}."
        stateless    = false
        protocol     = "TCP"
        src          = local.oke_vcn3_workers_subnet_cidr
        src_type     = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn3_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn3_pods_subnet_cidr
        src_type    = "CIDR_BLOCK"
        dst_port_min = 30000
        dst_port_max = 32767
      }
    } : {},
    ## Ingress from on-premises CIDRs
    # (local.add_oke_vcn2 == true && (var.oke_vcn2_attach_to_drg == true && var.oke_vcn2_onprem_route_enable)) &&
    # (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
    #   for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM-${cidr}-RULE" => {
    #     description  = "Ingress from onprem ${cidr}"
    #     stateless    = false
    #     protocol     = "TCP"
    #     src          = cidr
    #     src_type     = "CIDR_BLOCK"
    #     dst_port_min = 30000
    #     dst_port_max = 32767
    #   }
    # } : {}
  )

  ### Cross VCN ingress rules to OKE-VCN-2 Pods subnet
  oke_vcn_2_to_pods_subnet_cross_vcn_ingress = merge(
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "INGRESS-FROM-OKE-VCN-1-WORKERS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn1_workers_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn1_workers_subnet_cidr
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn1 == true && var.oke_vcn1_attach_to_drg == true) &&
    (upper(var.oke_vcn1_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1")))) ? {
      "INGRESS-FROM-OKE-VCN-1-PODS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn1_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn1_pods_subnet_cidr
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-WORKERS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn3_workers_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn3_workers_subnet_cidr
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true && var.add_oke_vcn3 == true && var.oke_vcn3_attach_to_drg == true) &&
    (upper(var.oke_vcn3_cni_type) == "NATIVE") &&
    (local.hub_with_vcn == true || (local.hub_with_drg_only == true && (length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3")))) ? {
      "INGRESS-FROM-OKE-VCN-3-PODS-SUBNET-RULE" = {
        description = "Ingress from ${local.oke_vcn3_pods_subnet_display_name}."
        stateless   = false
        protocol    = "TCP"
        src         = local.oke_vcn3_pods_subnet_cidr
        src_type    = "CIDR_BLOCK"
      }
    } : {},
    ## Ingress from on-premises CIDRs
    # (local.add_oke_vcn2 == true && (var.oke_vcn2_attach_to_drg == true && var.oke_vcn2_onprem_route_enable)) &&
    # (local.hub_with_vcn == true || local.hub_with_drg_only == true) ? {
    #   for cidr in var.onprem_cidrs : "INGRESS-FROM-ONPREM-${cidr}-RULE" => {
    #     description  = "Ingress from onprem ${cidr}"
    #     stateless    = false
    #     protocol     = "TCP"
    #     src          = cidr
    #     src_type     = "CIDR_BLOCK"
    #   }
    # } : {}
  )

  oke_vcn_2_drg_routing = (local.add_oke_vcn2 == true && var.oke_vcn2_attach_to_drg == true) ? merge(
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-1") ? local.tt_vcn1_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-2") ? local.tt_vcn2_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "TT-VCN-3") ? local.tt_vcn3_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-1") ? local.oke_vcn1_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "OKE-VCN-3") ? local.oke_vcn3_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-1") ? local.exa_vcn1_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-2") ? local.exa_vcn2_route_rule : {},
    length(var.oke_vcn2_routable_vcns) == 0 || contains(var.oke_vcn2_routable_vcns, "EXA-VCN-3") ? local.exa_vcn3_route_rule : {},
    var.oke_vcn2_onprem_route_enable == true ? local.on_prem_route_rule : {}
  ) : {}
}