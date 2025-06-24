resource "aws_macie2_classification_export_configuration" "security" {
  depends_on = [
    aws_macie2_account.example,
  ]
  s3_destination {
    bucket_name = aws_s3_bucket.example.bucket
    key_prefix  = "exampleprefix/"
    kms_key_arn = aws_kms_key.example.arn
  }
}
