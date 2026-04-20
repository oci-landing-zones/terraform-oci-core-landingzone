# EXA VCN Overrides Design

## Goal

Add Exadata VCN override support that matches the existing Three-Tier and OKE override model for all three Exa VCNs, while preserving the current default behavior when no overrides are supplied.

The new override surface must cover:

- per-subnet security list overrides for `client`, `backup`, and `integration`
- additional NSGs
- per-VCN CIS checks enablement
- intra-VCN DRG routing between `client` and `integration` subnets

## Requirements

- `locals_overrides.tf` must define override locals for `EXA-VCN-1`, `EXA-VCN-2`, and `EXA-VCN-3`.
- `net_override.tf` must include commented sample override entries for the new Exa locals, following the existing TT and OKE style.
- Each Exa VCN object must expose `enable_cis_checks`, driven by its new override local.
- Each Exa VCN must support custom subnet security lists for:
  - `client`
  - `backup`
  - `integration`
- The `backup` override must only be consumed when the backup subnet is enabled.
- The `integration` override must only be consumed when the integration subnet is enabled.
- Custom security lists must follow the same attachment model already used by TT and OKE spoke overrides: only attach the custom security list when the override is set and the VCN is attached to a Hub VCN through the DRG.
- The current default Exa behavior must remain unchanged when no override is provided:
  - `client` keeps its managed security list
  - `backup` keeps no security list attached
  - `integration` keeps no security list attached
- Each Exa VCN must merge user-provided `*_additional_nsgs` into the managed NSG set, without replacing managed NSGs.
- Each Exa VCN must support `*_enable_intra_vcn_drg_route`, but only for `client <-> integration` routes.
- `backup` route tables must keep their current OSN-only behavior; this change does not introduce `backup <-> client` or `backup <-> integration` DRG routing.

## Design

### Override locals

Add the following locals to `locals_overrides.tf` for each Exa VCN:

- `exa_vcn*_client_subnet_security_list = null`
- `exa_vcn*_backup_subnet_security_list = null`
- `exa_vcn*_integration_subnet_security_list = null`
- `exa_vcn*_additional_nsgs = {}`
- `exa_vcn*_cis_checks_enabled = true`
- `exa_vcn*_enable_intra_vcn_drg_route = false`

This mirrors the TT and OKE override surface and keeps the defaults safe-by-default.

### Sample override file

Add matching commented examples to `net_override.tf`, reusing `security_lists_default_ingress_rules` and `security_lists_default_egress_rules` for the security list examples, and the existing `additional_nsgs` example style for custom NSGs.

The sample comments should make two behaviors explicit:

- `backup` overrides only apply when the backup subnet is enabled
- `integration` overrides only apply when the integration subnet is enabled

### EXA VCN files

Update:

- `net_exacs_vcn_1.tf`
- `net_exacs_vcn_2.tf`
- `net_exacs_vcn_3.tf`

Each file should adopt the same override pattern already used in the TT and OKE VCN files.

#### CIS checks

Add `enable_cis_checks = local.exa_vcn*_cis_checks_enabled` to each Exa VCN object.

#### Subnet security list attachment

Update subnet definitions so:

- `client` uses `CUSTOM-EXA-VCN-*-CLIENT-SUBNET-SL` when `local.exa_vcn*_client_subnet_security_list != null` and the spoke is attached to a Hub VCN through the DRG; otherwise it keeps `EXA-VCN-*-CLIENT-SUBNET-SL`
- `backup` uses `CUSTOM-EXA-VCN-*-BACKUP-SUBNET-SL` when `local.exa_vcn*_backup_subnet_security_list != null`, the backup subnet is enabled, and the spoke is attached to a Hub VCN through the DRG; otherwise it attaches no security list
- `integration` uses `CUSTOM-EXA-VCN-*-INTEGRATION-SUBNET-SL` when `local.exa_vcn*_integration_subnet_security_list != null`, the integration subnet is enabled, and the spoke is attached to a Hub VCN through the DRG; otherwise it attaches no security list

This preserves the existing default Exa subnet posture while allowing overrides on all Exa subnet types.

#### Security list map

Extend each Exa `security_lists` block so it merges in custom security lists when present:

- `CUSTOM-EXA-VCN-*-CLIENT-SUBNET-SL`
- `CUSTOM-EXA-VCN-*-BACKUP-SUBNET-SL`
- `CUSTOM-EXA-VCN-*-INTEGRATION-SUBNET-SL`

The existing managed client security list remains unchanged and continues to be created by default.

No new managed default security lists are introduced for `backup` or `integration` in this change; only custom overrides may attach those security lists.

#### Additional NSGs

Extend each Exa `network_security_groups = merge(...)` block to include `local.exa_vcn*_additional_nsgs`, following the same pattern used by OKE and TT VCNs.

This ensures user-provided NSGs supplement rather than replace the managed Exa NSGs.

#### Intra-VCN DRG routing

Extend Exa route tables so `local.exa_vcn*_enable_intra_vcn_drg_route == true && var.exa_vcn*_attach_to_drg == true` adds Hub DRG route rules only between `client` and `integration`:

- `EXA-VCN-*-CLIENT-SUBNET-ROUTE-TABLE` gains a route to the integration subnet CIDR through `HUB-DRG` when the integration subnet exists
- `EXA-VCN-*-INTEGRATION-SUBNET-ROUTE-TABLE` gains a route to the client subnet CIDR through `HUB-DRG`

The `backup` route table remains unchanged and continues to route only to OSN through the Service Gateway.

### Documentation impact

This change only introduces local override knobs. It does not add new input variables, so no `schema.yml`, `SPEC.md`, or `VARIABLES.md` updates are required.

## Files

- `locals_overrides.tf`
- `net_override.tf`
- `net_exacs_vcn_1.tf`
- `net_exacs_vcn_2.tf`
- `net_exacs_vcn_3.tf`

## Verification

- Run `terraform152 fmt` on changed Terraform files.
- Run `terraform152 fmt -check` on changed Terraform files.
- Run `git diff --check` on changed files.
- Run `terraform152 validate` if the repo has already been initialized cleanly enough to validate; otherwise record the existing repo-level blocker separately from the Exa override changes.
