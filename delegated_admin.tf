resource "aws_macie2_organization_admin_account" "delegate_admin_sec_acc" {
  count            = var.macie_organization_management_account ? 1 : 0
  admin_account_id = var.organization_security_account_id
}

resource "aws_macie2_member" "members" {
  count                                 = var.macie_organization_security_account ? length(var.organization_member_account_ids) : 0
  account_id                            = var.organization_member_account_ids[count.index]
  email                                 = var.macie_notification_mail
  invite                                = var.invite_member_account # this is optional
  invitation_message                    = "aws macie invitation from itgix landing zones admin"
  invitation_disable_email_notification = var.disable_email_notification
}
