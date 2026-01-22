# Output con información de los usuarios creados
output "created_member_users" {
  value = {
    for upn, user in azuread_user.member_users : upn => {
      object_id           = user.object_id
      display_name        = user.display_name
      user_principal_name = user.user_principal_name
      department          = user.department
      user_type           = "Member"
    }
  }
  description = "Usuarios internos (members) creados en Azure AD"
}

output "invited_guest_users" {
  value = {
    for upn, invitation in azuread_invitation.guest_users : upn => {
      user_id            = invitation.user_id
      user_email_address = invitation.user_email_address
      redeem_url         = invitation.redeem_url
      user_type          = "Guest"
      display_name       = local.guest_users[upn].nombre_completo
    }
  }
  description = "Usuarios externos (guests) invitados a Azure AD"
}

output "user_passwords" {
  value = {
    for upn, user in local.member_users : upn => {
      password = user.password != "" ? user.password : var.default_password
    }
  }
  sensitive   = true
  description = "Contraseñas iniciales de usuarios internos (SENSIBLE - guardar de forma segura)"
}

output "summary" {
  value = {
    total_member_users_created = length(azuread_user.member_users)
    total_guest_users_invited  = length(azuread_invitation.guest_users)
    total_groups_created       = length(azuread_group.auto_groups)
    domain                     = data.azuread_domains.aad_domains.domains[0].domain_name
  }
  description = "Resumen de la creación de usuarios"
}

# Output con las asignaciones de roles
output "role_assignments" {
  value = {
    for group_name, assignment in azurerm_role_assignment.group_mg_roles : group_name => {
      group_name            = group_name
      role                  = local.group_config[group_name].role
      entorno               = local.group_config[group_name].entorno
      management_group_id   = local.group_config[group_name].management_group_id
      management_group_name = data.azurerm_management_group.mgs[local.group_config[group_name].management_group_id].display_name
      scope                 = assignment.scope
    }
  }
  description = "Asignaciones de roles RBAC a nivel de Management Group por entorno"
}

# Output de validación (grupos sin MG configurado)
output "groups_without_mg" {
  value = [
    for group_name, config in local.group_config : {
      group   = group_name
      entorno = config.entorno
    }
    if config.management_group_id == ""
  ]
  description = "Grupos sin Management Group configurado (entorno no mapeado o vacío)"
}

# Output de resumen por entorno
output "groups_by_environment" {
  value = {
    for entorno in distinct([for g, c in local.group_config : c.entorno if c.entorno != ""]) :
    entorno => [
      for group_name, config in local.group_config : group_name
      if config.entorno == entorno
    ]
  }
  description = "Grupos agrupados por entorno"
}