variable "noncurrent_version_transition_days" {
  type        = number
  default     = 90
  description = "Assuming Asustor uploads to Glacier - minimum storage duration charge for it is 90 days. Moves old versions of files (including deleted files) after X days to a cheaper storage class."
}

variable "noncurrent_version_transition_storage_class" {
  type        = string
  default     = "DEEP_ARCHIVE"
  description = "Assuming Asustor uploads to Glacier - moves old versions of files (including deleted files) to Deep Archive."
}

variable "noncurrent_version_expiration_days" {
  type        = number
  default     = 180
  description = "Minimum storage duration charge for Deep Archive is 180 days. Completely deletes old versions of files (including deleted files) after X days."
}

variable "iam_pgp_key" {
  type        = string
  default     = null
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key#pgp_key. If `null` - will not encrypt the resulting secret."
}
