variable "zpr_security_attributes_namespace" {
  default     = "<service-label>-zpr"
  description = "the name of ZPR security attribute namespace"
  type        = string
}

variable "enable_zpr" {
  default     = false
  description = "Flag to enable ZPR service"
  type        = bool
}
