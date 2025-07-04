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

# custom data identifier
variable "enable_custom_data_identifier" {
  type        = bool
  default     = false
  description = "Wether to enable the use of custom data identifiers"
}

variable "custom_data_identifier_name" {
  type        = string
  default     = "itgix_landing_zone"
  description = "Name of the custom data identifier"
}

variable "custom_data_identifier_description" {
  type        = string
  default     = "aws macie custom data identifier - itgix landing zone"
  description = "Description of the custom data identifier"
}

variable "custom_data_identifier_regex" {
  type        = string
  default     = ""
  description = "The regular expression (regex) that defines the pattern to match. The expression can contain as many as 512 characters. - example [0-9]{3}-[0-9]{2}-[0-9]{4}"
}

variable "custom_data_identifier_keywords" {
  type        = list(string)
  default     = []
  description = "An array that lists specific character sequences (keywords), one of which must be within proximity (maximum_match_distance) of the regular expression to match. The array can contain as many as 50 keywords. Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive."
}

variable "custom_data_identifier_ignore_words" {
  type        = list(string)
  default     = []
  description = "An array that lists specific character sequences (ignore words) to exclude from the results. If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. The array can contain as many as 10 ignore words. Each ignore word can contain 4 - 90 characters. Ignore words are case sensitive."
}

variable "custom_data_identifier_maximum_match_distance" {
  type        = number
  default     = 10
  description = "The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array. Macie includes or excludes a result based on the proximity of a keyword to text that matches the regex pattern. The distance can be 1 - 300 characters. The default value is 50."
}

# classification job
variable "one_time_classification_job" {
  type        = bool
  default     = false
  description = "Wether to enable or disable the creation of classification jobs"
}

variable "classification_job_type" {
  type        = string
  default     = "ONE_TIME"
  description = "Valid values are: ONE_TIME - Run the job only once. If you specify this value, don't specify a value for the schedule_frequency property. SCHEDULED - Run the job on a daily, weekly, or monthly basis. If you specify this value, use the schedule_frequency property to define the recurrence pattern for the job."
}

variable "daily_classification_job_description" {
  type = string
  default = "Weekly classification job for S3 data"
  description = "Description for the daily classification job"
}

variable "classification_job_schedule_frequency" {
  type =
  default = 
  description = "he recurrence pattern for running the job. To run the job only once, don't specify a value for this property and set the value for the job_type property to ONE_TIME"
}

variable "scheduled_jobs" {
  description = "List of Macie scheduled job configurations"
  type = list(object({
    job_name      = string
    description   = string
    job_type      = string         # ONE_TIME or SCHEDULED
    schedule_type = string         # DAILY, WEEKLY, MONTHLY (used only if job_type == SCHEDULED)
    bucket_names  = list(string)
    initial_run   = bool
    day_of_week   = optional(string)  # Only for WEEKLY
    day_of_month  = optional(number)  # Only for MONTHLY
  }))
}
