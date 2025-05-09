# OCI Landing Zone Generic IAM Extension Deployment Guide

This template shows how to deploy IAM resources for a generic workload using an OCI Core Landing Zone configuration.
Compartments, groups and policies are deployed to facilitate "segregation of duties" for an application workload on the landing zone base layer.

The following prerequisite resources are assumed to exist prior to deploying this extension:

- A foundation landing zone with minimal, basic IAM structure.

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value | Options |
|---|---|---|---|
| workload\_compartment\_name | The name of the workload to be deployed. | workload-cmp | |
| service\_label | A unique label that gets prepended to all resources deployed by the Landing Zone. Max length: 15 characters. | | |
| parent\_compartment\_ocid | The OCID of the parent compartment of the Landing Zone deployed. | | |
| isolate\_workload | The workload uses an isolated approach where network will be contained within the workload compartment instead of a shared network compartment. | false | |
| network\_compartment\_ocid | Network Compartment OCID. Ensure that the selected network compartment is within the selected parent compartment. | | |
| security\_compartment\_ocid | Security Compartment OCID. Ensure that the selected security compartment is within the selected parent compartment. | | |
| create\_workload\_app\_subcompartment | Create workload app sub-compartment? | false | |
| create\_workload\_network\_subcompartment | Create workload network sub-compartment? | false | |
| create\_workload\_database\_subcompartment | Create workload database sub-compartment? | false | |
| use\_custom\_identity\_domain | Use custom identity domain in parent landing zone? | false | |
| custom\_identity\_domain\_ocid | The OCID of custom identity domain. | | |
| custom\_identity\_domain\_name | The Name of custom identity domain. | | |
| enable\_db\_admin\_group | Enable database admin group? | false | |
| customize\_group\_name | Customize group names? | false | |
| workload\_admin\_group\_name | Workload admin group name. | workload-admin-group | |
| workload\_app\_admin\_group\_name | Workload app admin group name. | workload-app-admin-group | |
| workload\_db\_admin\_group\_name | Workload database admin group name. | workload-db-admin-group | |

For a detailed description of all variables that can be used, see the [Variables](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/blob/main/VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:

	``
	terraform init
	``
	
	``
	terraform plan
	``
	
	``
	terraform apply
	``

