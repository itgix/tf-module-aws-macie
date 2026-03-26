The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Macie Terraform Module

This module enables Amazon Macie across an AWS Organization with delegated admin, member account associations, custom data identifiers, and classification jobs.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- Macie account configuration
- Member account associations
- *(Optional)* Custom data identifiers
- *(Optional)* Classification jobs (one-time, daily, weekly, monthly)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `organization_security_account_id` | AWS Account ID of the security account | `string` | `null` | no |
| `macie_organization_security_account` | Set to true when running from organization security account | `bool` | `false` | no |
| `organization_member_account_ids` | List of member account IDs where Macie will be enabled | `list(any)` | `[]` | no |
| `macie_notification_mail` | Email address for security notifications | `string` | `"aws-landing-zones@itgix.com"` | no |
| `invite_member_account` | Whether to invite accounts as members | `bool` | `false` | no |
| `disable_email_notification` | Whether to disable email notification for new members | `bool` | `true` | no |
| `enable_custom_data_identifier` | Whether to enable a custom data identifier | `bool` | `false` | no |
| `custom_data_identifier_name` | Name of the custom data identifier | `string` | `"itgix_landing_zone"` | no |
| `custom_data_identifier_description` | Description of the custom data identifier | `string` | `"aws macie custom data identifier - itgix landing zone"` | no |
| `custom_data_identifier_regex` | Regex pattern for the custom data identifier | `string` | `""` | no |
| `custom_data_identifier_keywords` | Keywords for the custom data identifier | `list(string)` | `[]` | no |
| `custom_data_identifier_ignore_words` | Ignore words for the custom data identifier | `list(string)` | `[]` | no |
| `custom_data_identifier_maximum_match_distance` | Maximum match distance for keywords | `number` | `10` | no |
| `macie_classification_jobs` | List of Macie classification jobs to create | `list(object({job_name, description, job_type, schedule_type, bucket_names, initial_run, day_of_week, day_of_month}))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `one_time_job_names` | Names of one-time classification jobs |
| `daily_job_names` | Names of daily classification jobs |
| `weekly_job_names` | Names of weekly classification jobs |
| `monthly_job_names` | Names of monthly classification jobs |

## Usage Example

```hcl
module "macie" {
  source = "path/to/tf-module-aws-macie"

  macie_organization_security_account = true
  organization_security_account_id    = "111111111111"

  organization_member_account_ids = [
    "222222222222",
    "333333333333"
  ]

  macie_classification_jobs = [
    {
      job_name    = "daily-s3-scan"
      description = "Daily scan of sensitive data buckets"
      job_type    = "SCHEDULED"
      schedule_type = "DAILY"
      bucket_names  = ["my-sensitive-data-bucket"]
      initial_run   = true
    }
  ]
}
```
