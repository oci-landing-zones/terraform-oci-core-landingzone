# EXA VCN Overrides Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add override locals and Exa VCN wiring for custom subnet security lists, additional NSGs, CIS toggle support, and optional intra-VCN DRG routing between Exa client and integration subnets.

**Architecture:** Keep the override definitions centralized in `locals_overrides.tf` and `net_override.tf`, then wire each Exa VCN file directly so it mirrors the existing TT and OKE override pattern. Preserve today’s default Exa behavior by only attaching custom security lists when an override is set and the spoke is attached to a Hub VCN through the DRG, while leaving backup routing unchanged except for optional custom security list attachment.

**Tech Stack:** Terraform HCL, `terraform152`, `rg`, Git

---

## File Map

- `locals_overrides.tf`
  - Add Exa override locals for `client`, `backup`, `integration`, `additional_nsgs`, `cis_checks_enabled`, and `enable_intra_vcn_drg_route`.
- `net_override.tf`
  - Add commented sample Exa override blocks that match the style already used for TT and OKE.
- `net_exacs_vcn_1.tf`
  - Wire Exa VCN 1 to consume the new override locals.
- `net_exacs_vcn_2.tf`
  - Wire Exa VCN 2 to consume the new override locals.
- `net_exacs_vcn_3.tf`
  - Wire Exa VCN 3 to consume the new override locals.

### Task 1: Add EXA Override Locals

**Files:**
- Modify: `locals_overrides.tf`
- Verify: `rg`, `git diff`

- [ ] **Step 1: Capture the current missing Exa override locals**

Run:

```bash
rg -n "exa_vcn[123]_(client|backup|integration)_subnet_security_list|exa_vcn[123]_additional_nsgs|exa_vcn[123]_cis_checks_enabled|exa_vcn[123]_enable_intra_vcn_drg_route" locals_overrides.tf
```

Expected: no matches

- [ ] **Step 2: Add the Exa override locals before the default security list section**

Insert this block in `locals_overrides.tf` after the `OKE VCN3 overrides` section and before `# Default security lists rules.`:

```hcl
    #-----------------------------------------------
    # EXA VCN1 overrides:
    #-----------------------------------------------
    # EXA VCN1 security lists.
    exa_vcn1_client_subnet_security_list      = null
    exa_vcn1_backup_subnet_security_list      = null
    exa_vcn1_integration_subnet_security_list = null
    # EXA VCN1 additional NSGs:
    exa_vcn1_additional_nsgs = {}
    # Whether CIS checks for exa_vcn1 VCN are enabled.
    exa_vcn1_cis_checks_enabled = true
    # Whether traffic between EXA VCN1 client and integration subnets is routed through DRG.
    exa_vcn1_enable_intra_vcn_drg_route = false

    #-----------------------------------------------
    # EXA VCN2 overrides:
    #-----------------------------------------------
    # EXA VCN2 security lists.
    exa_vcn2_client_subnet_security_list      = null
    exa_vcn2_backup_subnet_security_list      = null
    exa_vcn2_integration_subnet_security_list = null
    # EXA VCN2 additional NSGs:
    exa_vcn2_additional_nsgs = {}
    # Whether CIS checks for exa_vcn2 VCN are enabled.
    exa_vcn2_cis_checks_enabled = true
    # Whether traffic between EXA VCN2 client and integration subnets is routed through DRG.
    exa_vcn2_enable_intra_vcn_drg_route = false

    #-----------------------------------------------
    # EXA VCN3 overrides:
    #-----------------------------------------------
    # EXA VCN3 security lists.
    exa_vcn3_client_subnet_security_list      = null
    exa_vcn3_backup_subnet_security_list      = null
    exa_vcn3_integration_subnet_security_list = null
    # EXA VCN3 additional NSGs:
    exa_vcn3_additional_nsgs = {}
    # Whether CIS checks for exa_vcn3 VCN are enabled.
    exa_vcn3_cis_checks_enabled = true
    # Whether traffic between EXA VCN3 client and integration subnets is routed through DRG.
    exa_vcn3_enable_intra_vcn_drg_route = false
```

- [ ] **Step 3: Re-run the local presence check**

Run:

```bash
rg -n "exa_vcn[123]_(client|backup|integration)_subnet_security_list|exa_vcn[123]_additional_nsgs|exa_vcn[123]_cis_checks_enabled|exa_vcn[123]_enable_intra_vcn_drg_route" locals_overrides.tf
```

Expected: all Exa VCN1/2/3 override locals appear exactly once each

- [ ] **Step 4: Commit**

Run:

```bash
git add locals_overrides.tf
git commit -m "feat: add exa vcn override locals"
```

Expected: commit succeeds with only `locals_overrides.tf` staged

### Task 2: Add Sample EXA Override Entries

**Files:**
- Modify: `net_override.tf`
- Verify: `rg`, `git diff`

- [ ] **Step 1: Confirm Exa override samples do not exist yet**

Run:

```bash
rg -n "exa_vcn[123]_(client|backup|integration)_subnet_security_list|exa_vcn[123]_additional_nsgs|exa_vcn[123]_cis_checks_enabled|exa_vcn[123]_enable_intra_vcn_drg_route" net_override.tf
```

Expected: no matches

- [ ] **Step 2: Add commented sample Exa override blocks above the default security list template section**

Insert this block in `net_override.tf` after the `OKE VCN3 overrides` examples and before `# Default security lists rules.`:

```hcl
#     #-----------------------------------------------
#     # EXA VCN1 overrides:
#     #-----------------------------------------------
#     # EXA VCN1 security lists.
#     exa_vcn1_client_subnet_security_list = {
#       display_name  = "client-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn1_backup_subnet = true.
#     exa_vcn1_backup_subnet_security_list = {
#       display_name  = "backup-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn1_integration_subnet = true.
#     exa_vcn1_integration_subnet_security_list = {
#       display_name  = "integration-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # EXA VCN1 additional NSGs.
#     exa_vcn1_additional_nsgs = {
#       "EXA-VCN-1-CUSTOM-NSG" = {
#         display_name = "exa-vcn-1-custom-nsg"
#         ingress_rules = {
#           "INGRESS-FROM-CIDR-TCP-RULE" = {
#             description  = "Ingress from 10.10.0.0/24 on SSH."
#             stateless    = false
#             protocol     = "TCP"
#             src          = "10.10.0.0/24"
#             src_type     = "CIDR_BLOCK"
#             dst_port_min = 22
#             dst_port_max = 22
#           }
#         }
#         egress_rules = {}
#       }
#     }
#     # Whether CIS checks for exa_vcn1 VCN are enabled.
#     exa_vcn1_cis_checks_enabled = false
#     # Whether traffic between EXA VCN1 client and integration subnets is routed through DRG.
#     exa_vcn1_enable_intra_vcn_drg_route = true
#
#     #-----------------------------------------------
#     # EXA VCN2 overrides:
#     #-----------------------------------------------
#     # EXA VCN2 security lists.
#     exa_vcn2_client_subnet_security_list = {
#       display_name  = "client-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn2_backup_subnet = true.
#     exa_vcn2_backup_subnet_security_list = {
#       display_name  = "backup-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn2_integration_subnet = true.
#     exa_vcn2_integration_subnet_security_list = {
#       display_name  = "integration-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # EXA VCN2 additional NSGs.
#     exa_vcn2_additional_nsgs = {}
#     # Whether CIS checks for exa_vcn2 VCN are enabled.
#     exa_vcn2_cis_checks_enabled = false
#     # Whether traffic between EXA VCN2 client and integration subnets is routed through DRG.
#     exa_vcn2_enable_intra_vcn_drg_route = true
#
#     #-----------------------------------------------
#     # EXA VCN3 overrides:
#     #-----------------------------------------------
#     # EXA VCN3 security lists.
#     exa_vcn3_client_subnet_security_list = {
#       display_name  = "client-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn3_backup_subnet = true.
#     exa_vcn3_backup_subnet_security_list = {
#       display_name  = "backup-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # Only applied when add_exa_vcn3_integration_subnet = true.
#     exa_vcn3_integration_subnet_security_list = {
#       display_name  = "integration-subnet-security-list"
#       ingress_rules = local.security_lists_default_ingress_rules
#       egress_rules  = local.security_lists_default_egress_rules
#     }
#     # EXA VCN3 additional NSGs.
#     exa_vcn3_additional_nsgs = {}
#     # Whether CIS checks for exa_vcn3 VCN are enabled.
#     exa_vcn3_cis_checks_enabled = false
#     # Whether traffic between EXA VCN3 client and integration subnets is routed through DRG.
#     exa_vcn3_enable_intra_vcn_drg_route = true
```

- [ ] **Step 3: Verify the samples are present**

Run:

```bash
rg -n "exa_vcn[123]_(client|backup|integration)_subnet_security_list|exa_vcn[123]_additional_nsgs|exa_vcn[123]_cis_checks_enabled|exa_vcn[123]_enable_intra_vcn_drg_route" net_override.tf
```

Expected: all sample override names appear in the commented example section

- [ ] **Step 4: Commit**

Run:

```bash
git add net_override.tf
git commit -m "docs: add exa vcn override examples"
```

Expected: commit succeeds with only `net_override.tf` staged

### Task 3: Wire EXA VCN 1 Overrides

**Files:**
- Modify: `net_exacs_vcn_1.tf`
- Verify: `rg`, `terraform152 fmt`

- [ ] **Step 1: Confirm the override hooks are missing in Exa VCN 1**

Run:

```bash
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-1|exa_vcn1_additional_nsgs|exa_vcn1_enable_intra_vcn_drg_route" net_exacs_vcn_1.tf
```

Expected: no matches

- [ ] **Step 2: Add the CIS flag and custom security list keys in the VCN and subnet blocks**

Update the top-level VCN object and subnet entries to this shape:

```hcl
  exa_vcn_1 = local.add_exa_vcn1 == true ? {
    "EXA-VCN-1" = {
      enable_cis_checks                = local.exa_vcn1_cis_checks_enabled
      display_name                     = local.exa_vcn1_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn1_cidrs,
      dns_label                        = local.exa_vcn1_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "exa-vcn-1" }] } : null
```

```hcl
          "EXA-VCN-1-CLIENT-SUBNET" = {
            cidr_block                = local.exa_vcn1_client_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn1_client_subnet_display_name
            dns_label                 = local.exa_vcn1_client_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-1-CLIENT-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn1_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-1-CLIENT-SUBNET-SL"] : ["EXA-VCN-1-CLIENT-SUBNET-SL"]
          }
```

```hcl
          "EXA-VCN-1-BACKUP-SUBNET" = {
            cidr_block                = local.exa_vcn1_backup_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn1_backup_subnet_display_name
            dns_label                 = local.exa_vcn1_backup_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-1-BACKUP-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn1_backup_subnet_security_list != null && local.add_exa_vcn1_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-1-BACKUP-SUBNET-SL"] : []
          }
```

```hcl
          "EXA-VCN-1-INTEGRATION-SUBNET" = {
            cidr_block                = local.exa_vcn1_integration_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn1_integration_subnet_display_name
            dns_label                 = local.exa_vcn1_integration_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-1-INTEGRATION-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn1_integration_subnet_security_list != null && local.add_exa_vcn1_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-1-INTEGRATION-SUBNET-SL"] : []
          }
```

- [ ] **Step 3: Add custom security list entries and merge additional NSGs**

Replace the `security_lists` block with a `merge(...)` and append `local.exa_vcn1_additional_nsgs` to `network_security_groups`:

```hcl
      security_lists = merge(
        {
          "EXA-VCN-1-CLIENT-SUBNET-SL" = {
            display_name = "${local.exa_vcn1_client_subnet_display_name}-security-list"
            ingress_rules = [
              {
                description  = "Allows TCP traffic from hosts in client subnet."
                stateless    = false
                protocol     = "TCP"
                src          = local.exa_vcn1_client_subnet_cidr
                src_type     = "CIDR_BLOCK"
              },
              {
                description  = "Allows ICMP traffic from hosts in client subnet."
                stateless    = false
                protocol     = "ICMP"
                src          = local.exa_vcn1_client_subnet_cidr
                src_type     = "CIDR_BLOCK"
              },
              {
                description  = "Allows external ICMP connections for path MTU discovery."
                stateless    = false
                protocol     = "ICMP"
                src          = "0.0.0.0/0"
                src_type     = "CIDR_BLOCK"
                icmp_type    = 3
                icmp_code    = 4
              }
            ]
            egress_rules = [
              {
                description  = "Allows TCP traffic to hosts in client subnet."
                stateless    = false
                protocol     = "TCP"
                dst          = local.exa_vcn1_client_subnet_cidr
                dst_type     = "CIDR_BLOCK"
              },
              {
                description  = "Allows ICMP traffic to hosts in client subnet."
                stateless    = false
                protocol     = "ICMP"
                dst          = local.exa_vcn1_client_subnet_cidr
                dst_type     = "CIDR_BLOCK"
              }
            ]
          }
        },
        local.exa_vcn1_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-1-CLIENT-SUBNET-SL" = local.exa_vcn1_client_subnet_security_list
        } : {},
        local.exa_vcn1_backup_subnet_security_list != null && local.add_exa_vcn1_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-1-BACKUP-SUBNET-SL" = local.exa_vcn1_backup_subnet_security_list
        } : {},
        local.exa_vcn1_integration_subnet_security_list != null && local.add_exa_vcn1_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-1-INTEGRATION-SUBNET-SL" = local.exa_vcn1_integration_subnet_security_list
        } : {}
      )
```

```hcl
      network_security_groups = merge(
        {
          "EXA-VCN-1-CLIENT-NSG" = {
            display_name = "client-nsg"
            ingress_rules = merge(
              local.hub_with_vcn == true && var.exa_vcn1_attach_to_drg == true && local.add_exa_vcn1 == true && var.deploy_bastion_jump_host == true ? {
                "INGRESS-FROM-SSH-HUB-VCN-RULE" = {
                  description  = "Allows SSH connections from ${local.hub_vcn_jumphost_subnet_cidr} in Hub VCN Jumphost subnet."
                  stateless    = false
                  protocol     = "TCP"
                  src          = local.hub_vcn_jumphost_subnet_cidr
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = 22
                  dst_port_max = 22
                }
              } : {},
              local.add_exa_vcn1_integration_subnet == true ? {
                for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-INTEGRATION-NSG-ON-${port}-RULE" => {
                  description  = "Ingress from Integration NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                  stateless    = false
                  protocol     = split(":", port)[0]
                  src          = "EXA-VCN-1-INTEGRATION-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                  dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                  icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                  icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
                }
              } : {},
              { for port in var.exa_vcn1_client_ingress_destination_ports : "INGRESS-FROM-CLIENT-NSG-ON-${port}-RULE" => {
                description  = "Ingress from Client NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                stateless    = false
                protocol     = split(":", port)[0]
                src          = "EXA-VCN-1-CLIENT-NSG"
                src_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
              { for cidr_port_pair in local.exa_vcn1_external_allowed_cidrs_to_ports_into_client_tier : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
                description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
                stateless    = false
                protocol     = split(":", split(",", cidr_port_pair)[1])[0]
                src          = split(",", cidr_port_pair)[0]
                src_type     = "CIDR_BLOCK"
                dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
                icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
              } },
              {
                "INGRESS-FROM-ONS-CLIENT-RULE" = {
                  description = "Allows Oracle Notification Services (ONS) communication from hosts in Client NSG for Fast Application Notifications (FAN)."
                  stateless   = false
                  protocol    = "TCP"
                  src         = "EXA-VCN-1-CLIENT-NSG"
                  src_type    = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6200
                  dst_port_max = 6200
                }
              }
            )
            egress_rules = merge(
              local.add_exa_vcn1_integration_subnet == true ? {
                for port in var.exa_vcn1_integration_ingress_destination_ports : "EGRESS-TO-INTEGRATION-NSG-ON-${port}-RULE" => {
                  description  = "Egress to Integration NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                  stateless    = false
                  protocol     = split(":", port)[0]
                  dst          = "EXA-VCN-1-INTEGRATION-NSG"
                  dst_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                  dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                  icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                  icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
                }
              } : {},
              { for port in var.exa_vcn1_client_ingress_destination_ports : "EGRESS-TO-CLIENT-NSG-ON-${port}-RULE" => {
                description  = "Egress to Client NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"} (for SQLNet connections)"
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "EXA-VCN-1-CLIENT-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                dst_port_max = split(":", port)[0] != "ICMP" ? (split(":", port)[1]) : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              } },
              {
                "EGRESS-TO-ONS-RULE" = {
                  description = "Allows Oracle Notification Services (ONS) communication to hosts in Client NSG for Fast Application Notifications (FAN)."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "EXA-VCN-1-CLIENT-NSG"
                  dst_type    = "NETWORK_SECURITY_GROUP"
                  dst_port_min = 6200
                  dst_port_max = 6200
                }
              },
              {
                "EGRESS-TO-OSN-RULE" = {
                  description = "Allows HTTPS connections to Oracle Services Network (OSN)."
                  stateless   = false
                  protocol    = "TCP"
                  dst         = "all-services"
                  dst_type    = "SERVICE_CIDR_BLOCK"
                  dst_port_min = 443
                  dst_port_max = 443
                }
              }
            )
          }
        },
        local.add_exa_vcn1_backup_subnet == true ? {
          "EXA-VCN-1-BACKUP-NSG" = {
            display_name = "backup-nsg"
            egress_rules = {
              "EGRESS-TO-OSN-RULE" = {
                description = "Allows HTTPS connections to Oracle Services Network (OSN)."
                stateless   = false
                protocol    = "TCP"
                dst         = "objectstorage"
                dst_type    = "SERVICE_CIDR_BLOCK"
                dst_port_min = 443
                dst_port_max = 443
              }
            }
          }
        } : {},
        local.add_exa_vcn1_integration_subnet == true ? {
          "EXA-VCN-1-INTEGRATION-NSG" = {
            display_name = "integration-nsg"
            ingress_rules = merge(
              {
                for port in var.exa_vcn1_integration_ingress_destination_ports : "INGRESS-FROM-CLIENT-NSG-ON-${port}-RULE" => {
                  description  = "Ingress from Client NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                  stateless    = false
                  protocol     = split(":", port)[0]
                  src          = "EXA-VCN-1-CLIENT-NSG"
                  src_type     = "NETWORK_SECURITY_GROUP"
                  dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                  dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                  icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                  icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
                }
              },
              {
                for cidr_port_pair in local.exa_vcn1_external_allowed_cidrs_to_ports_into_integration_tier : "INGRESS-FROM-${split(",", cidr_port_pair)[0]}-ON-${split(",", cidr_port_pair)[1]}-RULE" => {
                  description  = "Ingress from ${split(",", cidr_port_pair)[0]} over ${split(":", split(",", cidr_port_pair)[1])[0]} on ${split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? "type/code ${split(":", split(",", cidr_port_pair)[1])[1]}" : "port ${split(":", split(",", cidr_port_pair)[1])[1]}"}."
                  stateless    = false
                  protocol     = split(":", split(",", cidr_port_pair)[1])[0]
                  src          = split(",", cidr_port_pair)[0]
                  src_type     = "CIDR_BLOCK"
                  dst_port_min = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                  dst_port_max = split(":", split(",", cidr_port_pair)[1])[0] != "ICMP" ? split(":", split(",", cidr_port_pair)[1])[1] : null
                  icmp_type    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[0] : null
                  icmp_code    = split(":", split(",", cidr_port_pair)[1])[0] == "ICMP" ? (length(split("/", split(":", split(",", cidr_port_pair)[1])[1])) > 1 ? split("/", split(":", split(",", cidr_port_pair)[1])[1])[1] : null) : null
                }
              }
            )
            egress_rules = {
              for port in var.exa_vcn1_client_ingress_destination_ports : "EGRESS-TO-CLIENT-NSG-ON-${port}-RULE" => {
                description  = "Egress to Client NSG over ${split(":", port)[0]} on ${split(":", port)[0] == "ICMP" ? "type/code ${split(":", port)[1]}" : "port ${split(":", port)[1]}"}."
                stateless    = false
                protocol     = split(":", port)[0]
                dst          = "EXA-VCN-1-CLIENT-NSG"
                dst_type     = "NETWORK_SECURITY_GROUP"
                dst_port_min = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                dst_port_max = split(":", port)[0] != "ICMP" ? split(":", port)[1] : null
                icmp_type    = split(":", port)[0] == "ICMP" ? split("/", split(":", port)[1])[0] : null
                icmp_code    = split(":", port)[0] == "ICMP" ? (length(split("/", split(":", port)[1])) > 1 ? split("/", split(":", port)[1])[1] : null) : null
              }
            }
          }
        } : {},
        local.exa_vcn1_cross_vcn_open_nsg,
        local.exa_vcn1_cross_vcn_client_nsg,
        local.exa_vcn1_cross_vcn_integration_nsg,
        local.exa_vcn1_additional_nsgs
      )
```

- [ ] **Step 4: Add optional client/integration DRG route injection**

Update the client and integration route tables to merge these additional route rules:

```hcl
          "EXA-VCN-1-CLIENT-SUBNET-ROUTE-TABLE" = {
            display_name = "client-subnet-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "EXA-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              (local.hub_with_vcn == false) ? merge(
                local.exa_vcn_1_drg_routing,
                local.add_exa_vcn1_integration_subnet == true && local.exa_vcn1_enable_intra_vcn_drg_route == true && var.exa_vcn1_attach_to_drg == true ? {
                  "INTEGRATION-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn1_integration_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn1_integration_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : merge(
                {
                  "HUB-DRG-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.add_exa_vcn1_integration_subnet == true && local.exa_vcn1_enable_intra_vcn_drg_route == true && var.exa_vcn1_attach_to_drg == true ? {
                  "INTEGRATION-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn1_integration_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn1_integration_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              )
            )
          }
```

```hcl
          "EXA-VCN-1-INTEGRATION-SUBNET-ROUTE-TABLE" = {
            display_name = "integration-subnet-route-table"
            route_rules = merge(
              {
                "OSN-RULE" = {
                  network_entity_key = "EXA-VCN-1-SERVICE-GATEWAY"
                  description        = "Traffic destined for all OCI services in Oracle Services Network is routed through the Service Gateway."
                  destination        = "all-services"
                  destination_type   = "SERVICE_CIDR_BLOCK"
                }
              },
              (local.hub_with_vcn == false) ? merge(
                local.exa_vcn_1_drg_routing,
                local.exa_vcn1_enable_intra_vcn_drg_route == true && var.exa_vcn1_attach_to_drg == true ? {
                  "CLIENT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn1_client_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn1_client_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              ) : merge(
                {
                  "HUB-DRG-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for networks outside the VCN is routed through the DRG."
                    destination        = "0.0.0.0/0"
                    destination_type   = "CIDR_BLOCK"
                  }
                },
                local.exa_vcn1_enable_intra_vcn_drg_route == true && var.exa_vcn1_attach_to_drg == true ? {
                  "CLIENT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn1_client_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn1_client_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
              )
            )
          }
```

- [ ] **Step 5: Format and verify Exa VCN 1**

Run:

```bash
terraform152 fmt net_exacs_vcn_1.tf
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-1|exa_vcn1_additional_nsgs|exa_vcn1_enable_intra_vcn_drg_route|INTEGRATION-SUBNET-RULE|CLIENT-SUBNET-RULE" net_exacs_vcn_1.tf
```

Expected: `terraform152 fmt` rewrites the file if needed; `rg` returns all newly added hooks

- [ ] **Step 6: Commit**

Run:

```bash
git add net_exacs_vcn_1.tf
git commit -m "feat: wire exa vcn1 overrides"
```

Expected: commit succeeds with only `net_exacs_vcn_1.tf` staged

### Task 4: Wire EXA VCN 2 Overrides

**Files:**
- Modify: `net_exacs_vcn_2.tf`
- Verify: `rg`, `terraform152 fmt`

- [ ] **Step 1: Confirm the override hooks are missing in Exa VCN 2**

Run:

```bash
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-2|exa_vcn2_additional_nsgs|exa_vcn2_enable_intra_vcn_drg_route" net_exacs_vcn_2.tf
```

Expected: no matches

- [ ] **Step 2: Add the CIS flag and custom security list keys in the VCN and subnet blocks**

Update the top-level VCN object and subnet entries to this shape:

```hcl
  exa_vcn_2 = local.add_exa_vcn2 == true ? {
    "EXA-VCN-2" = {
      enable_cis_checks                = local.exa_vcn2_cis_checks_enabled
      display_name                     = local.exa_vcn2_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn2_cidrs,
      dns_label                        = local.exa_vcn2_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "exa-vcn-2" }] } : null
```

```hcl
          "EXA-VCN-2-CLIENT-SUBNET" = {
            cidr_block                = local.exa_vcn2_client_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn2_client_subnet_display_name
            dns_label                 = local.exa_vcn2_client_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-2-CLIENT-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn2_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-2-CLIENT-SUBNET-SL"] : ["EXA-VCN-2-CLIENT-SUBNET-SL"]
          }
```

```hcl
          "EXA-VCN-2-BACKUP-SUBNET" = {
            cidr_block                = local.exa_vcn2_backup_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn2_backup_subnet_display_name
            dns_label                 = local.exa_vcn2_backup_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-2-BACKUP-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn2_backup_subnet_security_list != null && local.add_exa_vcn2_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-2-BACKUP-SUBNET-SL"] : []
          }
```

```hcl
          "EXA-VCN-2-INTEGRATION-SUBNET" = {
            cidr_block                = local.exa_vcn2_integration_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn2_integration_subnet_display_name
            dns_label                 = local.exa_vcn2_integration_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-2-INTEGRATION-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn2_integration_subnet_security_list != null && local.add_exa_vcn2_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-2-INTEGRATION-SUBNET-SL"] : []
          }
```

- [ ] **Step 3: Replace the security list block and append the additional NSG merge for Exa VCN 2**

```hcl
      security_lists = merge(
        {
          "EXA-VCN-2-CLIENT-SUBNET-SL" = {
            display_name = "${local.exa_vcn2_client_subnet_display_name}-security-list"
            ingress_rules = [
              {
                description = "Allows TCP traffic from hosts in client subnet."
                stateless   = false
                protocol    = "TCP"
                src         = local.exa_vcn2_client_subnet_cidr
                src_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows ICMP traffic from hosts in client subnet."
                stateless   = false
                protocol    = "ICMP"
                src         = local.exa_vcn2_client_subnet_cidr
                src_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows external ICMP connections for path MTU discovery."
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
            egress_rules = [
              {
                description = "Allows TCP traffic to hosts in client subnet."
                stateless   = false
                protocol    = "TCP"
                dst         = local.exa_vcn2_client_subnet_cidr
                dst_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows ICMP traffic to hosts in client subnet."
                stateless   = false
                protocol    = "ICMP"
                dst         = local.exa_vcn2_client_subnet_cidr
                dst_type    = "CIDR_BLOCK"
              }
            ]
          }
        },
        local.exa_vcn2_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-2-CLIENT-SUBNET-SL" = local.exa_vcn2_client_subnet_security_list
        } : {},
        local.exa_vcn2_backup_subnet_security_list != null && local.add_exa_vcn2_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-2-BACKUP-SUBNET-SL" = local.exa_vcn2_backup_subnet_security_list
        } : {},
        local.exa_vcn2_integration_subnet_security_list != null && local.add_exa_vcn2_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn2_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-2-INTEGRATION-SUBNET-SL" = local.exa_vcn2_integration_subnet_security_list
        } : {}
      )
```

```hcl
        local.exa_vcn2_cross_vcn_open_nsg,
        local.exa_vcn2_cross_vcn_client_nsg,
        local.exa_vcn2_cross_vcn_integration_nsg,
        local.exa_vcn2_additional_nsgs
      )
```

- [ ] **Step 4: Add optional client/integration DRG route injection**

Update the route tables to add:

```hcl
                local.add_exa_vcn2_integration_subnet == true && local.exa_vcn2_enable_intra_vcn_drg_route == true && var.exa_vcn2_attach_to_drg == true ? {
                  "INTEGRATION-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn2_integration_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn2_integration_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
```

and:

```hcl
                local.exa_vcn2_enable_intra_vcn_drg_route == true && var.exa_vcn2_attach_to_drg == true ? {
                  "CLIENT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn2_client_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn2_client_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
```

Insert the `INTEGRATION-SUBNET-RULE` map into the client route table merge in both route branches:

- the `local.hub_with_vcn == false` branch that currently starts from `local.exa_vcn_2_drg_routing`
- the `local.hub_with_vcn == true` branch that currently starts from `"HUB-DRG-RULE"`

Insert the `CLIENT-SUBNET-RULE` map into the integration route table merge in both route branches:

- the `local.hub_with_vcn == false` branch that currently starts from `local.exa_vcn_2_drg_routing`
- the `local.hub_with_vcn == true` branch that currently starts from `"HUB-DRG-RULE"`

- [ ] **Step 5: Format and verify Exa VCN 2**

Run:

```bash
terraform152 fmt net_exacs_vcn_2.tf
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-2|exa_vcn2_additional_nsgs|exa_vcn2_enable_intra_vcn_drg_route|INTEGRATION-SUBNET-RULE|CLIENT-SUBNET-RULE" net_exacs_vcn_2.tf
```

Expected: `terraform152 fmt` rewrites the file if needed; `rg` returns all newly added hooks

- [ ] **Step 6: Commit**

Run:

```bash
git add net_exacs_vcn_2.tf
git commit -m "feat: wire exa vcn2 overrides"
```

Expected: commit succeeds with only `net_exacs_vcn_2.tf` staged

### Task 5: Wire EXA VCN 3 Overrides

**Files:**
- Modify: `net_exacs_vcn_3.tf`
- Verify: `rg`, `terraform152 fmt`

- [ ] **Step 1: Confirm the override hooks are missing in Exa VCN 3**

Run:

```bash
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-3|exa_vcn3_additional_nsgs|exa_vcn3_enable_intra_vcn_drg_route" net_exacs_vcn_3.tf
```

Expected: no matches

- [ ] **Step 2: Add the CIS flag and custom security list keys in the VCN and subnet blocks**

Update the top-level VCN object and subnet entries to this shape:

```hcl
  exa_vcn_3 = local.add_exa_vcn3 == true ? {
    "EXA-VCN-3" = {
      enable_cis_checks                = local.exa_vcn3_cis_checks_enabled
      display_name                     = local.exa_vcn3_display_name
      is_ipv6enabled                   = false
      is_oracle_gua_allocation_enabled = false
      cidr_blocks                      = var.exa_vcn3_cidrs,
      dns_label                        = local.exa_vcn3_dns_label
      block_nat_traffic                = false
      security                         = local.enable_zpr == true ? { zpr_attributes = [{ namespace : "${local.zpr_namespace_name}", attr_name : "net", attr_value : "exa-vcn-3" }] } : null
```

```hcl
          "EXA-VCN-3-CLIENT-SUBNET" = {
            cidr_block                = local.exa_vcn3_client_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn3_client_subnet_display_name
            dns_label                 = local.exa_vcn3_client_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-3-CLIENT-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn3_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-3-CLIENT-SUBNET-SL"] : ["EXA-VCN-3-CLIENT-SUBNET-SL"]
          }
```

```hcl
          "EXA-VCN-3-BACKUP-SUBNET" = {
            cidr_block                = local.exa_vcn3_backup_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn3_backup_subnet_display_name
            dns_label                 = local.exa_vcn3_backup_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-3-BACKUP-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn3_backup_subnet_security_list != null && local.add_exa_vcn3_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-3-BACKUP-SUBNET-SL"] : []
          }
```

```hcl
          "EXA-VCN-3-INTEGRATION-SUBNET" = {
            cidr_block                = local.exa_vcn3_integration_subnet_cidr
            dhcp_options_key          = "default_dhcp_options"
            display_name              = local.exa_vcn3_integration_subnet_display_name
            dns_label                 = local.exa_vcn3_integration_subnet_dns_label
            ipv6cidr_blocks           = []
            prohibit_internet_ingress = true
            route_table_key           = "EXA-VCN-3-INTEGRATION-SUBNET-ROUTE-TABLE"
            security_list_keys        = local.exa_vcn3_integration_subnet_security_list != null && local.add_exa_vcn3_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? ["CUSTOM-EXA-VCN-3-INTEGRATION-SUBNET-SL"] : []
          }
```

- [ ] **Step 3: Replace the security list block and append the additional NSG merge for Exa VCN 3**

```hcl
      security_lists = merge(
        {
          "EXA-VCN-3-CLIENT-SUBNET-SL" = {
            display_name = "${local.exa_vcn3_client_subnet_display_name}-security-list"
            ingress_rules = [
              {
                description = "Allows TCP traffic from hosts in client subnet."
                stateless   = false
                protocol    = "TCP"
                src         = local.exa_vcn3_client_subnet_cidr
                src_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows ICMP traffic from hosts in client subnet."
                stateless   = false
                protocol    = "ICMP"
                src         = local.exa_vcn3_client_subnet_cidr
                src_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows external ICMP connections for path MTU discovery."
                stateless   = false
                protocol    = "ICMP"
                src         = "0.0.0.0/0"
                src_type    = "CIDR_BLOCK"
                icmp_type   = 3
                icmp_code   = 4
              }
            ]
            egress_rules = [
              {
                description = "Allows TCP traffic to hosts in client subnet."
                stateless   = false
                protocol    = "TCP"
                dst         = local.exa_vcn3_client_subnet_cidr
                dst_type    = "CIDR_BLOCK"
              },
              {
                description = "Allows ICMP traffic to hosts in client subnet."
                stateless   = false
                protocol    = "ICMP"
                dst         = local.exa_vcn3_client_subnet_cidr
                dst_type    = "CIDR_BLOCK"
              }
            ]
          }
        },
        local.exa_vcn3_client_subnet_security_list != null && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-3-CLIENT-SUBNET-SL" = local.exa_vcn3_client_subnet_security_list
        } : {},
        local.exa_vcn3_backup_subnet_security_list != null && local.add_exa_vcn3_backup_subnet == true && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-3-BACKUP-SUBNET-SL" = local.exa_vcn3_backup_subnet_security_list
        } : {},
        local.exa_vcn3_integration_subnet_security_list != null && local.add_exa_vcn3_integration_subnet == true && (local.hub_with_vcn == true && var.exa_vcn3_attach_to_drg == true) ? {
          "CUSTOM-EXA-VCN-3-INTEGRATION-SUBNET-SL" = local.exa_vcn3_integration_subnet_security_list
        } : {}
      )
```

```hcl
        local.exa_vcn3_cross_vcn_open_nsg,
        local.exa_vcn3_cross_vcn_client_nsg,
        local.exa_vcn3_cross_vcn_integration_nsg,
        local.exa_vcn3_additional_nsgs
      )
```

- [ ] **Step 4: Add optional client/integration DRG route injection**

Update the route tables to add:

```hcl
                local.add_exa_vcn3_integration_subnet == true && local.exa_vcn3_enable_intra_vcn_drg_route == true && var.exa_vcn3_attach_to_drg == true ? {
                  "INTEGRATION-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn3_integration_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn3_integration_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
```

and:

```hcl
                local.exa_vcn3_enable_intra_vcn_drg_route == true && var.exa_vcn3_attach_to_drg == true ? {
                  "CLIENT-SUBNET-RULE" = {
                    network_entity_key = "HUB-DRG"
                    description        = "Traffic destined for ${local.exa_vcn3_client_subnet_display_name} is routed through the DRG."
                    destination        = local.exa_vcn3_client_subnet_cidr
                    destination_type   = "CIDR_BLOCK"
                  }
                } : {}
```

Insert the `INTEGRATION-SUBNET-RULE` map into the client route table merge in both route branches:

- the `local.hub_with_vcn == false` branch that currently starts from `local.exa_vcn_3_drg_routing`
- the `local.hub_with_vcn == true` branch that currently starts from `"HUB-DRG-RULE"`

Insert the `CLIENT-SUBNET-RULE` map into the integration route table merge in both route branches:

- the `local.hub_with_vcn == false` branch that currently starts from `local.exa_vcn_3_drg_routing`
- the `local.hub_with_vcn == true` branch that currently starts from `"HUB-DRG-RULE"`

- [ ] **Step 5: Format and verify Exa VCN 3**

Run:

```bash
terraform152 fmt net_exacs_vcn_3.tf
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-3|exa_vcn3_additional_nsgs|exa_vcn3_enable_intra_vcn_drg_route|INTEGRATION-SUBNET-RULE|CLIENT-SUBNET-RULE" net_exacs_vcn_3.tf
```

Expected: `terraform152 fmt` rewrites the file if needed; `rg` returns all newly added hooks

- [ ] **Step 6: Commit**

Run:

```bash
git add net_exacs_vcn_3.tf
git commit -m "feat: wire exa vcn3 overrides"
```

Expected: commit succeeds with only `net_exacs_vcn_3.tf` staged

### Task 6: Run Final Verification

**Files:**
- Verify: `locals_overrides.tf`, `net_override.tf`, `net_exacs_vcn_1.tf`, `net_exacs_vcn_2.tf`, `net_exacs_vcn_3.tf`

- [ ] **Step 1: Format all changed Terraform files**

Run:

```bash
terraform152 fmt locals_overrides.tf net_override.tf net_exacs_vcn_1.tf net_exacs_vcn_2.tf net_exacs_vcn_3.tf
```

Expected: Terraform formats any remaining spacing/alignment issues

- [ ] **Step 2: Verify formatting is clean**

Run:

```bash
terraform152 fmt -check locals_overrides.tf net_override.tf net_exacs_vcn_1.tf net_exacs_vcn_2.tf net_exacs_vcn_3.tf
```

Expected: exit code `0` and no file names printed

- [ ] **Step 3: Verify whitespace and patch health**

Run:

```bash
git diff --check -- locals_overrides.tf net_override.tf net_exacs_vcn_1.tf net_exacs_vcn_2.tf net_exacs_vcn_3.tf
```

Expected: no output other than line-ending warnings already present in this repo

- [ ] **Step 4: Run a final Exa-specific grep**

Run:

```bash
rg -n "enable_cis_checks|CUSTOM-EXA-VCN-[123]-(CLIENT|BACKUP|INTEGRATION)-SUBNET-SL|exa_vcn[123]_additional_nsgs|exa_vcn[123]_enable_intra_vcn_drg_route" locals_overrides.tf net_override.tf net_exacs_vcn_1.tf net_exacs_vcn_2.tf net_exacs_vcn_3.tf
```

Expected: every new override local and every custom security list hook appears in the expected files

- [ ] **Step 5: Run Terraform validation and record the outcome honestly**

Run:

```bash
terraform152 validate -no-color
```

Expected: if repo initialization/provider state is still blocked, the pre-existing repo-level module/provider errors should appear; do not treat unrelated repo-level validation blockers as Exa override regressions

- [ ] **Step 6: Commit the completed implementation**

Run:

```bash
git add locals_overrides.tf net_override.tf net_exacs_vcn_1.tf net_exacs_vcn_2.tf net_exacs_vcn_3.tf
git commit -m "feat: add exa vcn overrides"
```

Expected: final commit captures the full Exa override implementation
