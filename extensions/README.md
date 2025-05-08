# OCI Landing Zones Extensions

![Landing Zone logo](../images/landing_zone_300.png)

Welcome to the [OCI Landing Zones (OLZ) Community](https://github.com/oci-landing-zones)! OCI Landing Zones simplify onboarding and running on OCI by providing design guidance, best practices, and pre-configured Terraform deployment templates for various architectures and use cases. These enable customers to easily provision a secure tenancy foundation in the cloud along with all required services, and reliably scale as workloads expand.

This folder is the parent level for extensions, that are Terraform modules that provide auxilliary capabilities on top of the Core Landing Zone foundataion.   Typically, these capabilities are resources for various customer workloads. By workload we mean resources that are typically deployed within a landing zone, and may trigger OCI consumption. By secure we mean they are designed to cover the key security features available in the OCI platform. When appropriate, the modules align with CIS OCI Foundations Benchmark recommendations.

The following extension categories are available:

- [Generic Identity and Access Management (IAM)](./iam_generic)
- [Generic Networking](./network_generic)

The modules in this collection are designed for flexibility, are straightforward to use, and enforce CIS OCI Foundations Benchmark recommendations when possible.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Help

Open an issue in this repository.

## License

Copyright (c) 2025 Oracle and/or its affiliates.
Released under the Universal Permissive License v1.0 as shown at <https://oss.oracle.com/licenses/upl/>.

## Known Issues <a id='known-issues'></a>

None
