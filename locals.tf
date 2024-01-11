locals {
  account_id = "766717188698"
  region = "us-west-2"
  env = "taupehome-prod"
  app = "taupehome"
  version = "version3"
  calls_history_lambda = "arn:aws:lambda:us-west-2:766717188698:function:lhg-prod-leadgen-api-ProcessCallsEvent-VWcyGpVcnxRP"
  data_s3_bucket = aws_s3_bucket.leadgen_data_storage.id
  hosting_bucket_id = aws_s3_bucket.leadgen_hosting_bucket.id
  cognito_user_pool_id_value = aws_cognito_user_pool.provisiong_dashboard.id
  user_pool_client_id_value = aws_cognito_user_pool_client.client.id
  provider_name_value = "cognito-idp.us-west-2.amazonaws.com/us-west-2_AYGKrSQtH"
  identity_pool_id = aws_cognito_identity_pool.provisiong_dashboard_identity_pool.id
  parameter_value = "{\"phnolimit\": 20, \"phnoavailability\": true, \"maxlimit\": 20, \"sessionmaxduration\": 600, \"libertyhomegaurddynamicpool\":\"LibertyHomeGuard\", \"defaultphonenumber\": \"8007319545\"}"
  sns_subscription_protocol = "email"
  sns_subscription_endpoint = "athiva-liberty-leadge-aaaaijs56luxpudrjj5sfnzmza@athivatechworkspace.slack.com"
  ctr_processor = data.aws_kinesis_stream.existing_ctr_processor_contact_kinesis_stream.arn
  agent_events = data.aws_kinesis_stream.existing_ctr_processor_kinesis_stream.arn
  cdn_cert_arn = "arn:aws:acm:us-east-1:766717188698:certificate/e246718c-c356-4714-80af-46434f06db8b"
  swap_object = "932895671/swap.js"

}

