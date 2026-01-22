# Leer el archivo CSV con los usuarios
locals {
  users_csv = csvdecode(file("${path.module}/usuarios.csv"))
  
  # Separar usuarios internos (members) y externos (guests)
  member_users = {
    for user in local.users_csv : user.user_principal_name => user
    if try(user.tipo_usuario, "member") == "member"
  }
  
  guest_users = {
    for user in local.users_csv : user.user_principal_name => user
    if try(user.tipo_usuario, "member") == "guest"
  }
  
  # Lista de grupos únicos del CSV
  groups_needed = toset(distinct([
    for user in local.users_csv : user.grupo if user.grupo != ""
  ]))
}
