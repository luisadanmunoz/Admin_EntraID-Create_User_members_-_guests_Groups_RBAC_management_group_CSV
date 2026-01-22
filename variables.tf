# variables.tf - Variables para Azure AD

variable "users_csv_file" {
  description = "Ruta al archivo CSV con los usuarios"
  type        = string
  default     = "ejemplo_usuarios.csv"
}

variable "default_password" {
  description = "Contraseña por defecto si no se especifica en el CSV"
  type        = string
  default     = "Passwordprueba123$"
  sensitive   = true
}

variable "force_password_change" {
  description = "Forzar cambio de contraseña en el primer login"
  type        = bool
  default     = true
}

variable "default_usage_location" {
  description = "Ubicación por defecto para los usuarios (código de país ISO)"
  type        = string
  default     = "ES"
}

variable "create_groups_if_not_exist" {
  description = "Crear grupos automáticamente si no existen"
  type        = bool
  default     = false
}

variable "assign_roles_to_management_group" {
  description = "Asignar roles a nivel de Management Group"
  type        = bool
  default     = true
}

variable "guest_invitation_message" {
  description = "Mensaje por defecto para invitaciones de usuarios guest"
  type        = string
  default     = "Has sido invitado a colaborar con nuestra organización en Azure AD."
}

variable "environment_config" {
  description = "Mapeo de entornos a Management Groups"
  type = map(object({
    management_group_id = string
  }))
  default = {}
}

variable "default_management_group_id" {
  description = "Management Group por defecto si no se especifica entorno"
  type        = string
  default     = ""
}