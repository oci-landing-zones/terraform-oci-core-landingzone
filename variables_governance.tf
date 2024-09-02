# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Cost Management - Budget
# ------------------------------------------------------
variable "budget_alert_threshold" {
  type        = number
  default     = 100
  description = "The threshold for triggering the alert expressed as a percentage of the monthly forecast spend. 100% is the default."
  validation {
    condition     = var.budget_alert_threshold > 0 && var.budget_alert_threshold < 10000
    error_message = "Validation failed for budget_alert_threshold: The threshold percentage should be greater than 0 and less than or equal to 10,000, with no leading zeros and a maximum of 2 decimal places."
  }
}
variable "budget_amount" {
  type        = number
  default     = 1000
  description = "The amount of the budget expressed as a whole number in the currency of the customer's rate card."
}
variable "create_budget" {
  type        = bool
  default     = false
  description = "If true, a budget is created for the enclosing compartment, based on forecast or actual spending."
}
variable "budget_alert_email_endpoints" {
  type        = list(string)
  default     = []
  description = "List of email addresses for budget alerts. (Type an email address and hit enter to enter multiple values)"
  validation {
    condition     = length([for e in var.budget_alert_email_endpoints : e if length(regexall("^[a-zA-Z0-9.!#$%&'*/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", e)) > 0]) == length(var.budget_alert_email_endpoints)
    error_message = "Validation failed budget_alert_email_endpoints: invalid email address."
  }
}
