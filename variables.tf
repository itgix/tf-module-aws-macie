# organization configs
variable "macie_organization_management_account" {
  type        = bool
  default     = false
  description = "Set to true when running from organization management account to configure the macie delegated admin"
}

variable "organization_security_account_id" {
  type        = string
  description = "AWS Account ID where Macie is deployed - security account"
  default     = null
}

variable "macie_organization_security_account" {
  type        = bool
  default     = false
  description = "Set to true when running from organization security account to configure the Guardduty in the organization and invite member accounts"
}

variable "organization_member_account_ids" {
  type        = list(any)
  description = "List of member account IDs where aws macie will be enabled"
  default     = []
}

variable "macie_notification_mail" {
  type        = string
  default     = "aws-landing-zones@itgix.com"
  description = "(Optional) e-mail address that can be provided to receive updates about security issues"
}

variable "invite_member_account" {
  type        = bool
  default     = false
  description = "(Optional) Boolean whether to invite the account to  as a member. Defaults to false."
}

variable "disable_email_notification" {
  type        = bool
  default     = true
  description = "(Optional) Boolean whether an email notification is sent to the accounts when new member accounts are registered. Defaults to false"
}
