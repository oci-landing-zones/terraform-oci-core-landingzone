# OCI Landing Zones Generic Network Extension

![Landing Zone logo](../../images/landing_zone_300.png)

Welcome to the [OCI Landing Zones (OLZ) Community](https://github.com/oci-landing-zones)! OCI Landing Zones simplify onboarding and running on OCI by providing design guidance, best practices, and pre-configured Terraform deployment templates for various architectures and use cases. These enable customers to easily provision a secure tenancy foundation in the cloud along with all required services, and reliably scale as workloads expand.

This folder defines a [Core Landing Zone](https://github.com/oci-landing-zones/terraform-oci-core-landingzone) generic extension for network resources. The objective is to augment a Core Landing Zone deployment with network resources for supporting the further deployment of workload resources that are not satisfied by Core Landing Zone features alone.

It is comprised of the following files:

- [net_vcn.tf](./net_vcn.tf)
- [sec_nsgs.tf](./sec_nsgs.tf)
- [sec_security_lists.tf](./sec_security_lists.tf)
- [variables_network.tf](./variables_network.tf)
- [variables_security.tf](./variables_security.tf)

For more details on the use and deployment of this extension, see the associated [deployment guide](./DEPLOYMENT-GUIDE.md). 
The modules in this collection are designed for flexibility, are straightforward to use, and enforce CIS OCI Foundations Benchmark recommendations when possible.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Help

Open an issue in this repository.

## License

Copyright (c) 2025 Oracle and/or its affiliates.
Released under the Universal Permissive License v1.0 as shown at <https://oss.oracle.com/licenses/upl/>.

## Known Issues <a id='known-issues'></a>

None
