# main.tf - Configuración principal para Azure AD

# Crear usuarios INTERNOS (members) en Azure AD
resource "azuread_user" "member_users" {
  for_each = local.member_users
  
  user_principal_name = each.value.user_principal_name
  display_name        = each.value.nombre_completo
  mail_nickname       = split("@", each.value.user_principal_name)[0]
  
  # Contraseña inicial
  password = each.value.password != "" ? each.value.password : var.default_password
  
  # Información adicional
  given_name  = try(each.value.nombre, "")
  surname     = try(each.value.apellido, "")
  job_title   = try(each.value.puesto, "")
  department  = try(each.value.departamento, "")
  
  # Deshabilitar usuario si está marcado
  account_enabled = try(each.value.habilitado == "true", true)
  
  usage_location = try(each.value.location, var.default_usage_location)
}

# Invitar usuarios EXTERNOS (guests) a Azure AD
resource "azuread_invitation" "guest_users" {
  for_each = local.guest_users
  
  user_email_address = each.value.user_principal_name
  redirect_url       = "https://portal.azure.com"
  
  message {
    body     = try(each.value.mensaje_invitacion, var.guest_invitation_message)
  }
}

# Asignar usuarios MEMBERS a grupos
resource "azuread_group_member" "member_group_membership" {
  for_each = {
    for user in local.users_csv : user.user_principal_name => user
    if user.grupo != "" && var.create_groups_if_not_exist && try(user.tipo_usuario, "member") == "member"
  }
  
  group_object_id  = azuread_group.auto_groups[each.value.grupo].id
  member_object_id = azuread_user.member_users[each.key].id
  
  depends_on = [
    azuread_group.auto_groups,
    azuread_user.member_users
  ]
}

# Asignar usuarios GUESTS a grupos
resource "azuread_group_member" "guest_group_membership" {
  for_each = {
    for user in local.users_csv : user.user_principal_name => user
    if user.grupo != "" && var.create_groups_if_not_exist && try(user.tipo_usuario, "member") == "guest"
  }
  
  group_object_id  = azuread_group.auto_groups[each.value.grupo].id
  member_object_id = azuread_invitation.guest_users[each.key].user_id
  
  depends_on = [
    azuread_group.auto_groups,
    azuread_invitation.guest_users
  ]
}