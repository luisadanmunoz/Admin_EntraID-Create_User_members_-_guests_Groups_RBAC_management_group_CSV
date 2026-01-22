# rbac.tf - Asignación de roles RBAC a nivel de Management Group


# Asignar roles a los grupos a nivel de Management Group
resource "azurerm_role_assignment" "group_mg_roles" {
  for_each = var.assign_roles_to_management_group && var.create_groups_if_not_exist ? {
    for group_name, config in local.group_config : group_name => config
    if config.management_group_id != ""
  } : {}

  scope                = data.azurerm_management_group.mgs[each.value.management_group_id].id
  role_definition_name = each.value.role
  principal_id         = azuread_group.auto_groups[each.key].object_id

  depends_on = [
    azuread_group.auto_groups
  ]
}
