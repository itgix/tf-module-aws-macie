resource "aws_macie2_findings_filter" "test" {
  name        = "NAME OF THE FINDINGS FILTER"
  description = "DESCRIPTION"
  position    = 1
  action      = "ARCHIVE"
  finding_criteria {
    criterion {
      field = "region"
      eq    = [data.aws_region.current.name]
    }
  }
  depends_on = [aws_macie2_account.test]
}
