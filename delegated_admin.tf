resource "aws_macie2_organization_admin_account" "security_acc" {
  count            = var.macie_organization_management_account ? 1 : 0
  admin_account_id = var.organization_security_account_id
  # TODO: do we need those ?
  depends_on = [aws_macie2_account.security_acc]
}

resource "aws_macie2_account" "security_acc" {
  count                        = var.macie_organization_security_account ? 1 : 0
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  status                       = "ENABLED"
}

resource "aws_macie2_member" "members" {
  count                                 = var.macie_organization_security_account ? length(var.organization_member_account_ids) : 0
  account_id                            = var.organization_member_account_ids[count.index]
  email                                 = var.macie_notification_mail
  invite                                = var.invite_member_account # this is optional
  invitation_message                    = "aws macie invitation from itgix landing zones admin"
  invitation_disable_email_notification = var.disable_email_notification
  # TODO: do we need those ?
  depends_on = [aws_macie2_account.security_acc]
}
