variable "zpr_security_attributes_namespace" {
  default     = "corelz-zpr"
  description = "the name of namespace of zpr security attributes"
  type        = string
}

variable "enable_zpr" {
  default     = false
  description = "Flag to enable ZPR service"
  type        = bool
}