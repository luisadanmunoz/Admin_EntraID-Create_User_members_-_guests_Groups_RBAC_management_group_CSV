# Obtener el dominio del tenant
data "azuread_domains" "aad_domains" {
  only_initial = true
}
# Crear un mapa de grupo → configuración desde el CSV
locals {
  # Extraer grupos únicos con sus roles y entornos
  group_config = {
    for group_name, users in {
      for user in local.users_csv : user.grupo => user...
      if user.grupo != ""
    } : group_name => {
      role        = try(users[0].rol_azure, "Reader")
      entorno     = try(users[0].entorno, "")
      management_group_id = try(
        var.environment_config[try(users[0].entorno, "")].management_group_id,
        var.default_management_group_id
      )
    }
  }
  
  # Lista única de todos los Management Groups necesarios
  unique_management_groups = toset(distinct([
    for group_name, config in local.group_config : config.management_group_id
    if config.management_group_id != ""
  ]))
}

# Obtener todos los Management Groups necesarios
data "azurerm_management_group" "mgs" {
  for_each = local.unique_management_groups
  name     = each.value
}
