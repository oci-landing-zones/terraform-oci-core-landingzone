output "compartments" {
  description = "The compartments in a single flat map."
  value       = var.deploy_workload_compartment ? { for k, v in module.workload_compartment[0].compartments : k => { name : v.name, id : v.id } } : null
}
