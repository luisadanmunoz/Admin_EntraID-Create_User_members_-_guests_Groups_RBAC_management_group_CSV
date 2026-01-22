# Contraseña por defecto
default_password = "?3FJThBDi3\[H,;E9P"

# Forzar cambio de contraseña en el primer login
force_password_change = true

# Ubicación
default_usage_location = "ES"

# Activar creación automática de grupos
create_groups_if_not_exist = true

# Asignar roles a Management Group
assign_roles_to_management_group = true

# Management Group por defecto (si el entorno no está configurado o está vacío)
default_management_group_id = "management_group_id"

# Mapeo de entornos a Management Groups
environment_config = {
  produccion = {
    management_group_id = "mg-produccion"
  }
  desarrollo = {
    management_group_id = "mg-desarrollo"
  }
}