# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

locals {
  #--------------------------------------------------------------------------
  #-- Any of these custom variables can be overriden in a _override.tf file
  #--------------------------------------------------------------------------
  custom_policies_defined_tags  = null
  custom_policies_freeform_tags = null
	
	# for shared resources use case: Both the network cmp and security cmp in policy 
	# statement are from parent LZ
  identity_domain_prefix = var.use_custom_identity_domain ? "${var.custom_identity_domain_name}/" : ""

  app_admin_group_name = "${local.identity_domain_prefix}${var.isolate_workload ? (var.customize_group_name ? local.custom_workload_app_admin_group.CUSTOM-WKL-APP-ADMIN-GROUP.name : local.default_workload_app_admin_group.DEFAULT-WKL-APP-ADMIN-GROUP.name) : ""}"

  db_admin_group_name = "${local.identity_domain_prefix}${var.isolate_workload && var.enable_db_admin_group ? ( var.customize_group_name ? local.custom_workload_db_admin_group.CUSTOM-WKL-DB-ADMIN-GROUP.name : local.default_workload_db_admin_group.DEFAULT-WKL-DB-ADMIN-GROUP.name) : ""}"

  wkld_admin_group_name = "${local.identity_domain_prefix}${var.customize_group_name ? local.custom_workload_admin_group.CUSTOM-WKL-ADMIN-GROUP.name : local.default_workload_admin_group.DEFAULT-WKL-ADMIN-GROUP.name}"

  service_label_workload_compartment_name = "${var.service_label}-${var.workload_compartment_name}"

  root_policy_statements = var.deploy_root_policies ? concat(
    [
      "allow group ${local.wkld_admin_group_name} to inspect compartments in tenancy",
      "allow group ${local.wkld_admin_group_name} to inspect users in tenancy",
      "allow group ${local.wkld_admin_group_name} to inspect groups in tenancy",
      "allow group ${local.wkld_admin_group_name} to use tag-namespaces in tenancy",
      "allow group ${local.wkld_admin_group_name} to use cloud-shell in tenancy",
      "allow group ${local.wkld_admin_group_name} to read usage-budgets in tenancy",
      "allow group ${local.wkld_admin_group_name} to read usage-reports in tenancy",
      "allow group ${local.wkld_admin_group_name} to inspect dynamic-groups in tenancy",
      "allow group ${local.wkld_admin_group_name} to read objectstorage-namespaces in tenancy",
    ],
    var.isolate_workload == true ? [
      "allow group ${local.app_admin_group_name} to inspect compartments in tenancy",
      "allow group ${local.app_admin_group_name} to inspect users in tenancy",
      "allow group ${local.app_admin_group_name} to inspect groups in tenancy",
      "allow group ${local.app_admin_group_name} to use tag-namespaces in tenancy",
      "allow group ${local.app_admin_group_name} to use cloud-shell in tenancy",
      "allow group ${local.app_admin_group_name} to read usage-budgets in tenancy",
      "allow group ${local.app_admin_group_name} to read usage-reports in tenancy",
      "allow group ${local.app_admin_group_name} to inspect dynamic-groups in tenancy",
      "allow group ${local.app_admin_group_name} to read objectstorage-namespaces in tenancy",
    ] : [],
    var.isolate_workload == true && var.enable_db_admin_group == true ? [
      "allow group ${local.db_admin_group_name} to inspect compartments in tenancy",
      "allow group ${local.db_admin_group_name} to inspect users in tenancy",
      "allow group ${local.db_admin_group_name} to inspect groups in tenancy",
      "allow group ${local.db_admin_group_name} to use tag-namespaces in tenancy",
      "allow group ${local.db_admin_group_name} to use cloud-shell in tenancy",
      "allow group ${local.db_admin_group_name} to read usage-budgets in tenancy",
      "allow group ${local.db_admin_group_name} to read usage-reports in tenancy",
      "allow group ${local.db_admin_group_name} to inspect dynamic-groups in tenancy",
      "allow group ${local.db_admin_group_name} to read objectstorage-namespaces in tenancy"
    ] : [],
    var.additional_root_policy_statements
  ) : []

  wkld_admin_policy_statements = var.deploy_wkld_policies ? concat([
      "allow group ${local.wkld_admin_group_name} to read all-resources in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage functions-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage api-gateway-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage ons-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage streams in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage cluster-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage alarms in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage metrics in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage logging-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage instance-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage volume-family in compartment ${local.service_label_workload_compartment_name} where all { request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${local.wkld_admin_group_name} to manage object-family in compartment ${local.service_label_workload_compartment_name} where all { request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${local.wkld_admin_group_name} to manage file-family in compartment ${local.service_label_workload_compartment_name} where all { request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${local.wkld_admin_group_name} to manage repos in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage orm-stacks in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage orm-jobs in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage orm-config-source-providers in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to read audit-events in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to read work-requests in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage bastion-session in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage cloudevents-rules in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to read instance-agent-plugins in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage keys in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to use key-delegate in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage secret-family in compartment ${local.service_label_workload_compartment_name}"
    ],
    # isolated and network are enabled, use the network subcompartment
    var.isolate_workload == true && var.create_workload_network_subcompartment == true ? [
      "allow group ${local.wkld_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage load-balancers in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      # manage network policies
      "allow group ${local.wkld_admin_group_name} to manage virtual-network-family in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage subnets in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage route-tables in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage network-security-groups in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.wkld_admin_group_name} to manage security-lists in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
    ] : [],
    var.isolate_workload == true && var.create_workload_network_subcompartment == false ? [
      "allow group ${local.wkld_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage load-balancers in compartment ${local.service_label_workload_compartment_name}",
      # manage network policies
      "allow group ${local.wkld_admin_group_name} to manage virtual-network-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage subnets in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage route-tables in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage network-security-groups in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.wkld_admin_group_name} to manage security-lists in compartment ${local.service_label_workload_compartment_name}",
    ] : [],
    var.isolate_workload == false && var.network_compartment_ocid != "" ? [
      "allow group ${local.wkld_admin_group_name} to read virtual-network-family in compartment id ${var.network_compartment_ocid}",
      "allow group ${local.wkld_admin_group_name} to use subnets in compartment id ${var.network_compartment_ocid}",
      "allow group ${local.wkld_admin_group_name} to use network-security-groups in compartment id ${var.network_compartment_ocid}",
      "allow group ${local.wkld_admin_group_name} to use vnics in compartment id ${var.network_compartment_ocid}",
      "allow group ${local.wkld_admin_group_name} to manage private-ips in compartment id ${var.network_compartment_ocid}",
    ] : [],
    # Security cmp policies
    var.security_compartment_ocid != "" ? [
    "allow group ${local.wkld_admin_group_name} to use vaults in compartment id ${var.security_compartment_ocid}",
    "allow group ${local.wkld_admin_group_name} to manage instance-images in compartment id ${var.security_compartment_ocid}",
    "allow group ${local.wkld_admin_group_name} to read vss-family in compartment id ${var.security_compartment_ocid}",
    "allow group ${local.wkld_admin_group_name} to use bastion in compartment id ${var.security_compartment_ocid}",
    "allow group ${local.wkld_admin_group_name} to manage bastion-session in compartment id ${var.security_compartment_ocid}",
    "allow group ${local.wkld_admin_group_name} to read logging-family in compartment id ${var.security_compartment_ocid}"
    ] : [],
  var.additional_wkld_admin_policy_statements
  ) : []

  app_main_policy_cmp = var.create_workload_app_subcompartment ? "${local.service_label_workload_compartment_name}:${var.service_label}-app-cmp" : local.service_label_workload_compartment_name

  app_admin_policy_statements = concat(
    [
      "allow group ${local.app_admin_group_name} to read all-resources in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage load-balancers in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage api-gateway-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use ons-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use streams in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use alarms in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use metrics in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use logging-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage instance-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage volume-family in compartment ${local.app_main_policy_cmp} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${local.app_admin_group_name} to manage object-family in compartment ${local.app_main_policy_cmp} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${local.app_admin_group_name} to manage file-family in compartment ${local.app_main_policy_cmp} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${local.app_admin_group_name} to manage orm-stacks in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage orm-jobs in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage orm-config-source-providers in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to read audit-events in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to read work-requests in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage bastion-session in compartment ${local.app_main_policy_cmp}", # [this refers to the bastion framework designed earlier]
      "allow group ${local.app_admin_group_name} to manage cloudevents-rules in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to read instance-agent-plugins in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage keys in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to use key-delegate in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to manage secret-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to read autonomous-database-family in compartment ${local.app_main_policy_cmp}",
      "allow group ${local.app_admin_group_name} to read database-family in compartment ${local.app_main_policy_cmp}"
    ],
    var.create_workload_network_subcompartment == true ? [
      "allow group ${local.app_admin_group_name} to read virtual-network-family in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.app_admin_group_name} to use subnets in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.app_admin_group_name} to use network-security-groups in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.app_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.app_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.app_admin_group_name} to use load-balancers in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp"
    ] : [],
    var.create_workload_network_subcompartment == false ? [
      "allow group ${local.app_admin_group_name} to read virtual-network-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.app_admin_group_name} to use subnets in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.app_admin_group_name} to use network-security-groups in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.app_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.app_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.app_admin_group_name} to use load-balancers in compartment ${local.service_label_workload_compartment_name}"
    ] : [],
    # security services, security compartment is from parent LZ
    var.security_compartment_ocid != "" ? [
      "allow group ${local.app_admin_group_name} to use vaults in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.app_admin_group_name} to manage instance-images in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.app_admin_group_name} to read vss-family in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.app_admin_group_name} to use bastion in compartment id ${var.security_compartment_ocid}", #[this refers to the bastion framework designed earlier]
      "allow group ${local.app_admin_group_name} to manage bastion-session in compartment id ${var.security_compartment_ocid}", #[this refers to the bastion framework designed earlier]
      "allow group ${local.app_admin_group_name} to read logging-family in compartment id ${var.security_compartment_ocid}"
    ] : [],
    var.additional_app_admin_policy_statements
  )

  db_main_policy_cmp = var.create_workload_database_subcompartment ? "${local.service_label_workload_compartment_name}:${var.service_label}-database-cmp" : local.service_label_workload_compartment_name

  db_admin_policy_statements = concat(
    [
      "allow group ${local.db_admin_group_name} to read all-resources in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage db-systems in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage db-nodes in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage db-homes in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage databases in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage pluggable-databases in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage db-backups in compartment ${local.db_main_policy_cmp}",
      "Allow group ${local.db_admin_group_name}  to manage target-databases in compartment ${local.db_main_policy_cmp}",
      "Allow group ${local.db_admin_group_name}  to manage database-family in compartment ${local.db_main_policy_cmp}",
      # "Allow group ${local.db_admin_group_name}  to manage autonomous-databases in compartment ${local.db_main_policy_cmp}",
      # "Allow group ${local.db_admin_group_name}  to manage autonomous-container-databases in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage autonomous-database-family in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage alarms in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage metrics in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage cloudevents-rules in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage object-family in compartment ${local.db_main_policy_cmp} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${local.db_admin_group_name} to manage instance-family in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage volume-family in compartment ${local.db_main_policy_cmp} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${local.db_admin_group_name} to manage file-family in compartment ${local.db_main_policy_cmp} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${local.db_admin_group_name} to manage orm-stacks in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage orm-jobs in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage orm-config-source-providers in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage ons-family in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage logging-family in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to read audit-events in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to read work-requests in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage bastion-session in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to read instance-agent-plugins in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage data-safe-family in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to use vnics in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage keys in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to use key-delegate in compartment ${local.db_main_policy_cmp}",
      "allow group ${local.db_admin_group_name} to manage secret-family in compartment ${local.db_main_policy_cmp}",
    ],
    var.create_workload_network_subcompartment == true ? [
      "allow group ${local.db_admin_group_name} to read virtual-network-family in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.db_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.db_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.db_admin_group_name} to use subnets in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
      "allow group ${local.db_admin_group_name} to use network-security-groups in compartment ${local.service_label_workload_compartment_name}:${var.service_label}-network-cmp",
    ] : [],
    var.create_workload_network_subcompartment == false ? [
      "allow group ${local.db_admin_group_name} to read virtual-network-family in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.db_admin_group_name} to use vnics in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.db_admin_group_name} to manage private-ips in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.db_admin_group_name} to use subnets in compartment ${local.service_label_workload_compartment_name}",
      "allow group ${local.db_admin_group_name} to use network-security-groups in compartment ${local.service_label_workload_compartment_name}",
    ] : [],
     # For security services
    var.security_compartment_ocid != "" ? [
      "allow group ${local.db_admin_group_name} to read vss-family in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.db_admin_group_name} to use vaults in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.db_admin_group_name} to read logging-family in compartment id ${var.security_compartment_ocid}",
      "allow group ${local.db_admin_group_name} to use bastion in compartment id ${var.security_compartment_ocid}", # [this refers to the bastion framework designed earlier]
      "allow group ${local.db_admin_group_name} to manage bastion-session in compartment id ${var.security_compartment_ocid}" # [this refers to the bastion framework designed earlier]
    ] : [],
    var.additional_db_admin_policy_statements
  )

  policies = merge(
      var.deploy_root_policies ? {
      "ROOT-POLICY" : {
        compartment_id = var.tenancy_ocid
        name = coalesce(var.root_policy_name, "${var.service_label}-root-policy")
        description = "Root policy statements"
        statements = local.root_policy_statements
      }
    } : {},
    var.deploy_wkld_policies ? {
      "WKLD-ADMIN-POLICY" : {
        compartment_id = var.parent_compartment_ocid
        name = coalesce(var.wkld_admin_policy_name, "${var.service_label}-wkld-admin-policy")
        description = "Workload admin policies"
        statements = local.wkld_admin_policy_statements
      }
    } : {},
      var.isolate_workload ? {
      "APP-ADMIN-POLICY" : {
        name = coalesce(var.app_admin_policy_name, "${var.service_label}-wkld-app-admin-policy")
        description = "Workload App Admin Policies"
        compartment_id = var.parent_compartment_ocid
        statements = local.app_admin_policy_statements
      }
    } : {},
      var.isolate_workload && var.enable_db_admin_group ? {
      "DB-ADMIN-POLICY" : {
        name = coalesce(var.db_admin_policy_name, "${var.service_label}-wkld-db-admin-policy")
        description = "Workload DB Admin Policies"
        compartment_id = var.parent_compartment_ocid
        statements = local.db_admin_policy_statements
      }
    } : {}
  )

  policies_configuration = {
   supplied_policies = local.policies
  }
}


module "workload_policies" {
  count                  = var.deploy_root_policies || var.deploy_wkld_policies ? 1 : 0
  depends_on             = [module.workload_default_domain_groups, module.workload_custom_domain_groups, module.workload_compartment, module.workload_sub_compartments]
  source                 = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.9"
  providers              = { oci = oci.home }
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = local.policies_configuration
}