# variable "account_profile" {
#     type = map
#     default = {
#         "preprod" = "uat-admin-profile"
#     }
# }

# variable "region" {
#     type = map
#     default = {
#         # "athiva" = "ap-south-1",
#         "preprod" = "us-east-1"
#     }
# }

# variable "sns_subscription_endpoint" {
#     type = map
#     default = {
#         "preprod"="deployment_discussion-aaaajkoko5tpmwxjfvdj64mv6e@athivatechworkspace.slack.com"
#     }  
# }

# variable "sns_subscription_protocol" {
#     type = map
#     default = {
#         "preprod"="email"
#     }  
# }

# variable "calls_history_table_function" {
#     type = map
#     default = {
#         "preprod"="arn:aws:lambda:us-east-1:553650805536:function:uat-leadgen-api-ProcessCallsEvent-HBUED2HfzZny"
#     }
# }