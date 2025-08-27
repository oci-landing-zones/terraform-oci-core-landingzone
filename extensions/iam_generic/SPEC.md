## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workload_compartment"></a> [workload\_compartment](#module\_workload\_compartment) | github.com/oci-landing-zones/terraform-oci-modules-iam//compartments | v0.2.9 |
| <a name="module_workload_custom_domain_groups"></a> [workload\_custom\_domain\_groups](#module\_workload\_custom\_domain\_groups) | github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains | v0.2.9 |
| <a name="module_workload_default_domain_groups"></a> [workload\_default\_domain\_groups](#module\_workload\_default\_domain\_groups) | github.com/oci-landing-zones/terraform-oci-modules-iam//groups | v0.2.9 |
| <a name="module_workload_policies"></a> [workload\_policies](#module\_workload\_policies) | github.com/oci-landing-zones/terraform-oci-modules-iam//policies | v0.2.9 |
| <a name="module_workload_sub_compartments"></a> [workload\_sub\_compartments](#module\_workload\_sub\_compartments) | github.com/oci-landing-zones/terraform-oci-modules-iam//compartments | v0.2.9 |

## Resources

| Name | Type |
|------|------|
| [oci_identity_compartment.lz_network_compartment](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |
| [oci_identity_compartment.lz_security_compartment](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |
| [oci_identity_domain.existing_identity_domain](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_domain) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_app_admin_policy_statements"></a> [additional\_app\_admin\_policy\_statements](#input\_additional\_app\_admin\_policy\_statements) | Additional statements to add to the root policy. Note that this this policy is created at the parent compartment of the workload. | `list(string)` | `[]` | no |
| <a name="input_additional_db_admin_policy_statements"></a> [additional\_db\_admin\_policy\_statements](#input\_additional\_db\_admin\_policy\_statements) | Additional statements to add to the root policy. Note that this this policy is created at the parent compartment of the workload. | `list(string)` | `[]` | no |
| <a name="input_additional_root_policy_statements"></a> [additional\_root\_policy\_statements](#input\_additional\_root\_policy\_statements) | Additional statements to add to the root policy. Note that this this policy is created at the root compartment. | `list(string)` | `[]` | no |
| <a name="input_additional_wkld_admin_policy_statements"></a> [additional\_wkld\_admin\_policy\_statements](#input\_additional\_wkld\_admin\_policy\_statements) | Additional statements to add to the workload admin policy. Note that this this policy is created at the parent compartment of the workload. | `list(string)` | `[]` | no |
| <a name="input_app_admin_policy_name"></a> [app\_admin\_policy\_name](#input\_app\_admin\_policy\_name) | App Admin policy name. | `string` | `"wkld-app-admin-policy"` | no |
| <a name="input_app_compartment_description"></a> [app\_compartment\_description](#input\_app\_compartment\_description) | App compartment description | `string` | `"Workload sub-compartment for all resources related to application development: compute instances, storage, functions, OKE, API Gateway, streaming, and others."` | no |
| <a name="input_create_workload_app_subcompartment"></a> [create\_workload\_app\_subcompartment](#input\_create\_workload\_app\_subcompartment) | the option to enable workload app compartment | `bool` | `false` | no |
| <a name="input_create_workload_database_subcompartment"></a> [create\_workload\_database\_subcompartment](#input\_create\_workload\_database\_subcompartment) | the option to enable workload database compartment | `bool` | `false` | no |
| <a name="input_create_workload_network_subcompartment"></a> [create\_workload\_network\_subcompartment](#input\_create\_workload\_network\_subcompartment) | the option to enable workload network compartment | `bool` | `false` | no |
| <a name="input_custom_identity_domain_name"></a> [custom\_identity\_domain\_name](#input\_custom\_identity\_domain\_name) | the name of custom identity domain | `string` | `""` | no |
| <a name="input_custom_identity_domain_ocid"></a> [custom\_identity\_domain\_ocid](#input\_custom\_identity\_domain\_ocid) | the OCID of custom identity domain | `string` | `""` | no |
| <a name="input_customize_group_policy_name"></a> [customize\_group\_policy\_name](#input\_customize\_group\_policy\_name) | the option to customize group and policy names | `bool` | `false` | no |
| <a name="input_database_compartment_description"></a> [database\_compartment\_description](#input\_database\_compartment\_description) | Database compartment description | `string` | `"Workload sub-compartment for all network related resources: VCNs, subnets, network gateways, security lists, NSGs, load balancers, VNICs, and others."` | no |
| <a name="input_db_admin_policy_name"></a> [db\_admin\_policy\_name](#input\_db\_admin\_policy\_name) | DB Admin policy name. | `string` | `"wkld-db-admin-policy"` | no |
| <a name="input_deploy_default_groups"></a> [deploy\_default\_groups](#input\_deploy\_default\_groups) | Whether or not to deploy groups | `bool` | `true` | no |
| <a name="input_deploy_root_policies"></a> [deploy\_root\_policies](#input\_deploy\_root\_policies) | Whether or not to deploy root policies | `bool` | `true` | no |
| <a name="input_deploy_wkld_policies"></a> [deploy\_wkld\_policies](#input\_deploy\_wkld\_policies) | Whether or not to deploy wkld policies | `bool` | `true` | no |
| <a name="input_deploy_workload_compartment"></a> [deploy\_workload\_compartment](#input\_deploy\_workload\_compartment) | Whether or not to deploy workload compartment | `bool` | `true` | no |
| <a name="input_enable_db_admin_group"></a> [enable\_db\_admin\_group](#input\_enable\_db\_admin\_group) | the option to enable workload database admin group | `bool` | `false` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | n/a | `string` | `""` | no |
| <a name="input_isolate_workload"></a> [isolate\_workload](#input\_isolate\_workload) | the option to isolate the workload | `bool` | `false` | no |
| <a name="input_lz_network_policy_name"></a> [lz\_network\_policy\_name](#input\_lz\_network\_policy\_name) | Landing Zone network policy name. | `string` | `null` | no |
| <a name="input_lz_security_policy_name"></a> [lz\_security\_policy\_name](#input\_lz\_security\_policy\_name) | Landing Zone security policy name. | `string` | `null` | no |
| <a name="input_network_compartment_description"></a> [network\_compartment\_description](#input\_network\_compartment\_description) | Network compartment description | `string` | `"Workload sub-compartment for all network related resources: VCNs, subnets, network gateways, security lists, NSGs, load balancers, VNICs, and others."` | no |
| <a name="input_network_compartment_ocid"></a> [network\_compartment\_ocid](#input\_network\_compartment\_ocid) | The network compartment OCID. Applicable when isolate\_workload is false. | `string` | `""` | no |
| <a name="input_override_group_names"></a> [override\_group\_names](#input\_override\_group\_names) | the option to override the default group names | `bool` | `false` | no |
| <a name="input_override_policy_names"></a> [override\_policy\_names](#input\_override\_policy\_names) | the option to override the default policy names | `bool` | `false` | no |
| <a name="input_parent_compartment_ocid"></a> [parent\_compartment\_ocid](#input\_parent\_compartment\_ocid) | the OCID of the root compartment in the parent landing zone | `string` | `""` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | n/a | `string` | `""` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where resources are deployed. | `string` | `""` | no |
| <a name="input_root_policy_name"></a> [root\_policy\_name](#input\_root\_policy\_name) | Root policy name. | `string` | `"root-policy"` | no |
| <a name="input_security_compartment_ocid"></a> [security\_compartment\_ocid](#input\_security\_compartment\_ocid) | The security compartment OCID. Applicable when isolate\_workload is false. | `string` | `""` | no |
| <a name="input_service_label"></a> [service\_label](#input\_service\_label) | A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters. | `string` | `""` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | ------------------------------------------------------ ----- General ------------------------------------------------------- | `string` | `""` | no |
| <a name="input_use_custom_identity_domain"></a> [use\_custom\_identity\_domain](#input\_use\_custom\_identity\_domain) | the flag to use custom identity domain in the parent landing zone | `bool` | `false` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | `""` | no |
| <a name="input_wkld_admin_policy_name"></a> [wkld\_admin\_policy\_name](#input\_wkld\_admin\_policy\_name) | Workload Admin policy name. | `string` | `"wkld-admin-policy"` | no |
| <a name="input_workload_admin_group_name"></a> [workload\_admin\_group\_name](#input\_workload\_admin\_group\_name) | the name of workload admin group | `string` | `"workload-admin-group"` | no |
| <a name="input_workload_app_admin_group_name"></a> [workload\_app\_admin\_group\_name](#input\_workload\_app\_admin\_group\_name) | the name of the workload app admin group | `string` | `"workload-app-admin-group"` | no |
| <a name="input_workload_app_subcompartment_name"></a> [workload\_app\_subcompartment\_name](#input\_workload\_app\_subcompartment\_name) | the name of the application sub-compartment | `string` | `null` | no |
| <a name="input_workload_compartment_description"></a> [workload\_compartment\_description](#input\_workload\_compartment\_description) | Workload compartment description | `string` | `"Workload compartment"` | no |
| <a name="input_workload_compartment_name"></a> [workload\_compartment\_name](#input\_workload\_compartment\_name) | the name of the workload compartment | `string` | `"workload-cmp"` | no |
| <a name="input_workload_database_subcompartment_name"></a> [workload\_database\_subcompartment\_name](#input\_workload\_database\_subcompartment\_name) | the name of the database sub-compartment | `string` | `null` | no |
| <a name="input_workload_db_admin_group_name"></a> [workload\_db\_admin\_group\_name](#input\_workload\_db\_admin\_group\_name) | the name of the workload database admin group | `string` | `"workload-db-admin-group"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compartments"></a> [compartments](#output\_compartments) | The compartments in a single flat map. |
