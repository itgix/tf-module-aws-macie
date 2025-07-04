# TODO:
# resource "aws_macie2_custom_data_identifier" "default" {
#   count = var.enable_custom_data_identifier ? 1 : 0
#
#   name                   = var.custom_data_identifier_name
#   description            = var.custom_data_identifier_description
#   regex                  = var.custom_data_identifier_regex
#   keywords               = var.custom_data_identifier_keywords
#   ignore_words           = var.custom_data_identifier_ignore_words
#   maximum_match_distance = var.custom_data_identifier_maximum_match_distance
#
#   # TODO: do we need this ? 
#   depends_on = [
#     aws_macie2_account.security_acc
#   ]
# }
