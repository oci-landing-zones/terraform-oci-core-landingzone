# Copyright (c) 2023, 2026, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# SAMPLE DUMMY override values
# Uncomment the variables and assign them appropriate values per your use case requirements.

locals {

#-----------------------------------------------
# IAM overrides:
#-----------------------------------------------

# --- For adding compartments to Core Landing Zone, override additional_enclosed_compartments variable with a map of additional compartments, like:
# additional_enclosed_compartments = {
#     DEVOPS-CMP = { 
#         name = "${var.service_label}-devops-cmp", 
#         description = "Core Landing Zone custom DevOps compartment" 
#     }
# }

# --- Custom policy statements to be added to the default policies created for the landing zone. A separate policy is created at the enclosing compartment of the landing zone, and only when the enclosing compartment is not the Root compartment.
# --- Use this with extreme caution as it may introduce security risks if not used properly. Make sure to follow the principle of least privilege when defining custom policies, and only grant the necessary permissions required for your use case.
# custom_policy_statements = ["allow group ${join(",", local.appdev_admin_group_name)} to manage sddcs in compartment ${local.app_compartment_name}"]

# --- Custom tag namespaces and tags to be provisioned by the landing zone. These are in addition to the default tag namespace and tags created for the landing zone, and can be used for custom tagging strategies.
# custom_tag_namespaces = {
#    MY-NAMESPACE = {
#        name        = "my-namespace"
#        description = "Tag namespace sample"
#        compartment_id = local.enclosing_compartment_id # optional, if not specified, the tag namespace is created in the Root compartment
#        is_retired  = false
#        tags = {
#            COST-CENTER-TAG = {
#                name             = "costcenter"
#                description      = "Cost center tag sample" # optional
#                is_cost_tracking = true                     # optional
#                valid_values     = ["1001", "1002", "1003"] # optional
#            }
#        }
#    }
# } 

}