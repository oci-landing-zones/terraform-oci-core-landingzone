# OCI Core Landing Zone

![Landing Zone logo](./images/landing_zone_300.png)

## CIS OCI Foundations Benchmark Modules Collection

This repository uses a broader collection of repositories containing modules that help customers align their OCI implementations with the CIS OCI Foundations Benchmark recommendations:
- [Identity & Access Management](https://github.com/oci-landing-zones/terraform-oci-modules-iam)
- [Networking](https://github.com/oci-landing-zones/terraform-oci-modules-networking)
- [Governance](https://github.com/oci-landing-zones/terraform-oci-modules-governance)
- [Security](https://github.com/oci-landing-zones/terraform-oci-modules-security)
- [Observability & Monitoring](https://oci-landing-zones/terraform-oci-modules-observability)
- [Secure Workloads](https://github.com/oci-landing-zones/terraform-oci-modules-workloads)

The modules in this collection are designed for flexibility, are straightforward to use, and enforce CIS OCI Foundations Benchmark recommendations when possible.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License
Copyright (c) 2023, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.

## Known Issues
None.