variable "name" {
  description = "FireWall group name"
  type        = string
  default     = "Managed by terraform"
}

variable "rules" {
  description = "Firewall rules"
  type = list(object({
    ports     = optional(list(number))
    protocol  = string
    direction = string
    cidrs     = optional(list(string))
  }))
  default = null
}

variable "resources" {
  description = "Resource information (id, type)"
  type = list(object({
    id   = string
    type = string
  }))
  default = null
}