# groups.tf - Gestión de grupos

# Crear grupos automáticamente si la variable está activada
resource "azuread_group" "auto_groups" {
  for_each = var.create_groups_if_not_exist ? toset(distinct([
    for user in local.users_csv : user.grupo if user.grupo != ""
  ])) : toset([])
  
  display_name     = each.value
  security_enabled = true
  mail_enabled     = false
  
  description = "Grupo creado automáticamente por Terraform"
}

# Output con los grupos creados
output "created_groups" {
  value = {
    for name, group in azuread_group.auto_groups : name => {
      object_id    = group.object_id
      display_name = group.display_name
    }
  }
  description = "Grupos creados automáticamente"
}