locals {
  daily_jobs = [
    for job in var.macie_classification_jobs : job
    if job.job_type == "SCHEDULED" && job.schedule_type == "DAILY"
  ]

  weekly_jobs = [
    for job in var.macie_classification_jobs : job
    if job.job_type == "SCHEDULED" && job.schedule_type == "WEEKLY"
  ]

  monthly_jobs = [
    for job in var.macie_classification_jobs : job
    if job.job_type == "SCHEDULED" && job.schedule_type == "MONTHLY"
  ]

  one_time_jobs = [
    for job in var.macie_classification_jobs : job
    if job.job_type == "ONE_TIME"
  ]
}

# One-Time Job
resource "aws_macie2_classification_job" "one_time" {
  count       = length(local.one_time_jobs)
  name        = local.one_time_jobs[count.index].job_name
  description = local.one_time_jobs[count.index].description
  job_type    = "ONE_TIME"

  s3_job_definition {
    bucket_definitions {
      account_id = var.organization_security_account_id
      buckets    = local.one_time_jobs[count.index].bucket_names
    }
  }

  initial_run = local.one_time_jobs[count.index].initial_run
}

# Scheduled Jobs
resource "aws_macie2_classification_job" "daily" {
  count       = length(local.daily_jobs)
  name        = local.daily_jobs[count.index].job_name
  description = local.daily_jobs[count.index].description
  job_type    = "SCHEDULED"

  s3_job_definition {
    bucket_definitions {
      account_id = var.organization_security_account_id
      buckets    = local.daily_jobs[count.index].bucket_names
    }
  }

  schedule_frequency {
    daily_schedule = true
  }

  initial_run = local.daily_jobs[count.index].initial_run
}

resource "aws_macie2_classification_job" "weekly" {
  count       = length(local.weekly_jobs)
  name        = local.weekly_jobs[count.index].job_name
  description = local.weekly_jobs[count.index].description
  job_type    = "SCHEDULED"

  s3_job_definition {
    bucket_definitions {
      account_id = var.organization_security_account_id
      buckets    = local.weekly_jobs[count.index].bucket_names
    }
  }

  schedule_frequency {
    weekly_schedule = local.weekly_jobs[count.index].day_of_week
  }

  initial_run = local.weekly_jobs[count.index].initial_run
}

resource "aws_macie2_classification_job" "monthly" {
  count       = length(local.monthly_jobs)
  name        = local.monthly_jobs[count.index].job_name
  description = local.monthly_jobs[count.index].description
  job_type    = "SCHEDULED"

  s3_job_definition {
    bucket_definitions {
      account_id = var.organization_security_account_id
      buckets    = local.monthly_jobs[count.index].bucket_names
    }
  }

  schedule_frequency {
    monthly_schedule = local.monthly_jobs[count.index].day_of_month
  }

  initial_run = local.monthly_jobs[count.index].initial_run
}
