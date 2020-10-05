locals {
  prefix       = var.prefix == "" ? "" : "${var.prefix}-"
  folders_list = [for name in var.names : google_folder.folders[name]]
  first_folder = local.folders_list[0]

  name_role_pairs = setproduct(var.names, var.folder_admin_roles)
  folder_admin_roles_map_data = zipmap(
    [for pair in local.name_role_pairs : "${pair[0]}-${pair[1]}"],
    [for pair in local.name_role_pairs : {
      name = pair[0]
      role = pair[1]
    }]
  )
}

resource "google_folder" "folders" {
  for_each = toset(var.names)

  display_name = "${local.prefix}${each.value}"
  parent       = var.parent
}

# give project creation access to service accounts
# https://cloud.google.com/resource-manager/docs/access-control-folders#granting_folder-specific_roles_to_enable_project_creation

resource "google_folder_iam_binding" "owners" {
  for_each = var.set_roles ? local.folder_admin_roles_map_data : {}
  folder   = google_folder.folders[each.value.name].name
  role     = each.value.role

  members = compact(
    concat(
      split(",",
        lookup(var.per_folder_admins, each.value.name, ""),
      ),
      var.all_folder_admins,
    ),
  )
}
