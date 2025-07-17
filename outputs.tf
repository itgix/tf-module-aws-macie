output "one_time_job_names" {
  value = [for job in aws_macie2_classification_job.one_time : job.name]
}

output "daily_job_names" {
  value = [for job in aws_macie2_classification_job.daily : job.name]
}

output "weekly_job_names" {
  value = [for job in aws_macie2_classification_job.weekly : job.name]
}

output "monthly_job_names" {
  value = [for job in aws_macie2_classification_job.monthly : job.name]
}
