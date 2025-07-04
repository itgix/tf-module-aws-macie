output "job_names" {
  value = [for job in aws_macie2_classification_job.this : job.name]
}
