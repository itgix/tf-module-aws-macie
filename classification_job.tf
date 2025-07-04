# One-Time Job
resource "aws_macie2_classification_job" "one_time_job" {
  count = (
    var.one_time_jobs != null && length(var.one_time_jobs) > 0 ? length(var.one_time_jobs) : 0
  )
  name        = "macie-one-time-job"
  job_type    = "ONE_TIME"
  description = "One-time Macie classification job"

  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.current.account_id
      buckets    = var.one_time_jobs[count.index].bucket_names
    }
  }

  initial_run                      = true
  managed_data_identifier_selector = "ALL"
}

# Schedule Job
resource "aws_macie2_classification_job" "scheduled_job" {
  count = (
    var.scheduled_jobs != null && length(var.scheduled_jobs) > 0 ? length(var.scheduled_jobs) : 0
  )
  name        = var.scheduled_jobs[count.index].job_name
  description = var.scheduled_jobs[count.index].description
  job_type    = var.scheduled_jobs[count.index].job_type

  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.current.account_id
      buckets    = var.scheduled_jobs[count.index].bucket_names
    }
  }

  dynamic "schedule_frequency" {
    for_each = var.scheduled_jobs[count.index].job_type == "SCHEDULED" ? [1] : []
    content {
      dynamic "daily_schedule" {
        for_each = var.scheduled_jobs[count.index].schedule_type == "DAILY" ? [1] : []
        content {}
      }

      dynamic "weekly_schedule" {
        for_each = var.scheduled_jobs[count.index].schedule_type == "WEEKLY" ? [1] : []
        content {
          day_of_week = var.scheduled_jobs[count.index].day_of_week
        }
      }

      dynamic "monthly_schedule" {
        for_each = var.scheduled_jobs[count.index].schedule_type == "MONTHLY" ? [1] : []
        content {
          day_of_month = var.scheduled_jobs[count.index].day_of_month
        }
      }
    }
  }

  initial_run                      = var.scheduled_jobs[count.index].initial_run
  managed_data_identifier_selector = "ALL"
}
