variable "parent" {
  type        = string
  description = "The resource name of the parent Folder or Organization. Must be of the form folders/folder_id or organizations/org_id"
}

variable "names" {
  type        = list(string)
  description = "Folder names."
  default     = []
}

variable "set_roles" {
  type        = bool
  description = "Enable setting roles via the folder admin variables."
  default     = false
}

variable "per_folder_admins" {
  type        = map(string)
  description = "IAM-style members per folder who will get extended permissions."
  default     = {}
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}

variable "prefix" {
  type        = string
  description = "Optional prefix to enforce uniqueness of folder names."
  default     = ""
}

variable "folder_admin_roles" {
  type        = list(string)
  description = "List of roles that will be applied to per folder owners on their respective folder."

  default = [
    "roles/owner",
    "roles/resourcemanager.folderViewer",
    "roles/resourcemanager.projectCreator",
    "roles/compute.networkAdmin",
  ]
}
