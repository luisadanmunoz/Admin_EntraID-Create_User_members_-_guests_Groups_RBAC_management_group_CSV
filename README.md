
# Admin Entra ID (Terraform): Usuarios, Grupos y RBAC desde CSV

Proyecto Terraform para automatizar tareas comunes de administración en **Microsoft Entra ID**:
- Creación/gestión de **usuarios** (miembros e invitados/guests) desde un **CSV**.
- Creación/gestión de **grupos**.
- **Asignaciones RBAC** (por ejemplo, a nivel de *Management Group*).

> Revisa los ficheros `variables.tf`, `provider.tf`, `groups.tf` y `rbac.tf` para ver el comportamiento exacto.

---

## Estructura del repo

- `provider.tf` → Providers y autenticación.
- `variables.tf` → Variables de entrada.
- `Admin_EntraID.tfvars` → Ejemplo de valores para variables (ajústalo a tu entorno).
- `usuarios.csv` → Fuente de usuarios (miembros/guests).
- `main.tf` / `locals.tf` / `data.tf` → Lógica principal, locales y data sources.
- `groups.tf` → Definición/gestión de grupos.
- `rbac.tf` → Asignaciones de roles (RBAC).
- `output.tf` → Salidas (IDs, nombres, etc.).

---

## Requisitos

- Terraform instalado (versión compatible con los providers definidos en `provider.tf`).
- Credenciales con permisos suficientes:
  - Entra ID: permisos para crear/gestionar usuarios y grupos (según lo que haga el código).
  - Azure: permisos para asignar roles (RBAC) en el alcance que use el repo (p.ej. Management Group).
- Acceso al tenant/suscripción/management group objetivo.

---

## Uso rápido

1) Clonar el repositorio:
```bash
git clone https://github.com/luisadanmunoz/Admin_EntraID-Create_User_members_-_guests_Groups_RBAC_management_group_CSV.git
cd Admin_EntraID-Create_User_members_-_guests_Groups_RBAC_management_group_CSV
