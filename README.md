The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

## AWS Macie
example module use

```
module "aws_macie_sec_acc" {
  # source = "git::https://gitlab.itgix.com/itgix-public/terraform-modules/macie.git?ref=v1.0"
  source = "git::https://gitlab.itgix.com/itgix-public/terraform-modules/macie.git"
  count  = var.macie_enabled ? 1 : 0

  # True because we run this in the Organization Management account to delegate the Security account as a delagated admin for AWS macie in the organization
  macie_organization_security_account = true
  organization_security_account_id    = data.aws_caller_identity.current.account_id

  # TODO: update this to dynamic taking of account IDs to avoid hardcoding
  # List of all application & shared services accounts that need to be scanned by AWS Macie 
  #organization_member_account_ids = [module.aws_organization.dev_account_id, module.aws_organization.stage_account_id, module.aws_organization.prod_account_id, module.aws_organization.shared_services_account_id]
  organization_member_account_ids = [
    # Dev account
    "767398095708",
    # Stage account
    "905418051897",
    # Prod account
    "381492288235",
    # Shared Services account
    "905418054535"
  ]

  macie_jobs = [
    // one-time jobs
    {
      job_name     = "macie-onetime"
      description  = "One-time scan"
      job_type     = "ONE_TIME"
      initial_run  = true
      bucket_names = ["itgix-landing-zone-security-tf-state"]
    },
    // scheduled jobs
    {
      job_name      = "macie-daily"
      description   = "Daily scan"
      job_type      = "SCHEDULED"
      schedule_type = "DAILY"
      initial_run   = true
      bucket_names  = ["itgix-landing-zone-security-tf-state"]
    },
    {
      job_name      = "macie-weekly"
      description   = "Weekly scan"
      job_type      = "SCHEDULED"
      schedule_type = "WEEKLY"
      day_of_week   = "MONDAY"
      bucket_names  = ["itgix-landing-zone-security-tf-state"]
      initial_run   = true
    },
    {
      job_name      = "macie-monthly"
      description   = "Monthly scan"
      job_type      = "SCHEDULED"
      schedule_type = "MONTHLY"
      day_of_month  = 1
      bucket_names  = ["itgix-landing-zone-security-tf-state"]
      initial_run   = true
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_macie2_classification_job.daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job) | resource |
| [aws_macie2_classification_job.monthly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job) | resource |
| [aws_macie2_classification_job.one_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job) | resource |
| [aws_macie2_classification_job.weekly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_job) | resource |
| [aws_macie2_custom_data_identifier.itgix_landing_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_custom_data_identifier) | resource |
| [aws_macie2_member.members](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_data_identifier_description"></a> [custom\_data\_identifier\_description](#input\_custom\_data\_identifier\_description) | Description of the custom data identifier | `string` | `"aws macie custom data identifier - itgix landing zone"` | no |
| <a name="input_custom_data_identifier_ignore_words"></a> [custom\_data\_identifier\_ignore\_words](#input\_custom\_data\_identifier\_ignore\_words) | An array that lists specific character sequences (ignore words) to exclude from the results. If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. The array can contain as many as 10 ignore words. Each ignore word can contain 4 - 90 characters. Ignore words are case sensitive. | `list(string)` | `[]` | no |
| <a name="input_custom_data_identifier_keywords"></a> [custom\_data\_identifier\_keywords](#input\_custom\_data\_identifier\_keywords) | An array that lists specific character sequences (keywords), one of which must be within proximity (maximum\_match\_distance) of the regular expression to match. The array can contain as many as 50 keywords. Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive. | `list(string)` | `[]` | no |
| <a name="input_custom_data_identifier_maximum_match_distance"></a> [custom\_data\_identifier\_maximum\_match\_distance](#input\_custom\_data\_identifier\_maximum\_match\_distance) | The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array. Macie includes or excludes a result based on the proximity of a keyword to text that matches the regex pattern. The distance can be 1 - 300 characters. The default value is 50. | `number` | `10` | no |
| <a name="input_custom_data_identifier_name"></a> [custom\_data\_identifier\_name](#input\_custom\_data\_identifier\_name) | Name of the custom data identifier | `string` | `"itgix_landing_zone"` | no |
| <a name="input_custom_data_identifier_regex"></a> [custom\_data\_identifier\_regex](#input\_custom\_data\_identifier\_regex) | The regular expression (regex) that defines the pattern to match. The expression can contain as many as 512 characters. - example [0-9]{3}-[0-9]{2}-[0-9]{4} | `string` | `""` | no |
| <a name="input_disable_email_notification"></a> [disable\_email\_notification](#input\_disable\_email\_notification) | (Optional) Boolean whether an email notification is sent to the accounts when new member accounts are registered. Defaults to false | `bool` | `true` | no |
| <a name="input_enable_custom_data_identifier"></a> [enable\_custom\_data\_identifier](#input\_enable\_custom\_data\_identifier) | Wether to enable the use of a custom data identifier in AWS Macie | `bool` | `false` | no |
| <a name="input_invite_member_account"></a> [invite\_member\_account](#input\_invite\_member\_account) | (Optional) Boolean whether to invite the account to  as a member. Defaults to false. | `bool` | `false` | no |
| <a name="input_macie_classification_jobs"></a> [macie\_classification\_jobs](#input\_macie\_classification\_jobs) | List of Macie classification jobs to create | <pre>list(object({<br/>    job_name      = string<br/>    description   = string<br/>    job_type      = string           # "SCHEDULED" or "ONE_TIME"<br/>    schedule_type = optional(string) # "DAILY", "WEEKLY", "MONTHLY"<br/>    bucket_names  = list(string)<br/>    initial_run   = bool<br/>    day_of_week   = optional(string) # for WEEKLY<br/>    day_of_month  = optional(number) # for MONTHLY<br/>  }))</pre> | `[]` | no |
| <a name="input_macie_notification_mail"></a> [macie\_notification\_mail](#input\_macie\_notification\_mail) | (Optional) e-mail address that can be provided to receive updates about security issues | `string` | `"aws-landing-zones@itgix.com"` | no |
| <a name="input_macie_organization_security_account"></a> [macie\_organization\_security\_account](#input\_macie\_organization\_security\_account) | Set to true when running from organization security account to configure the Guardduty in the organization and invite member accounts | `bool` | `false` | no |
| <a name="input_organization_member_account_ids"></a> [organization\_member\_account\_ids](#input\_organization\_member\_account\_ids) | List of member account IDs where aws macie will be enabled | `list(any)` | `[]` | no |
| <a name="input_organization_security_account_id"></a> [organization\_security\_account\_id](#input\_organization\_security\_account\_id) | AWS Account ID where Macie is deployed - security account | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_daily_job_names"></a> [daily\_job\_names](#output\_daily\_job\_names) | n/a |
| <a name="output_monthly_job_names"></a> [monthly\_job\_names](#output\_monthly\_job\_names) | n/a |
| <a name="output_one_time_job_names"></a> [one\_time\_job\_names](#output\_one\_time\_job\_names) | n/a |
| <a name="output_weekly_job_names"></a> [weekly\_job\_names](#output\_weekly\_job\_names) | n/a |
<!-- END_TF_DOCS -->
