output "account_id" {
  value = local.account_id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.leadgen_data_storage.id
}