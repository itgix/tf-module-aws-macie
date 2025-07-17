# macie


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
```
