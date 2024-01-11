resource "aws_s3_bucket" "leadgen_data_storage" {

    bucket                      = "leadgen-${local.env}-data-storage"
    object_lock_enabled         = false

    request_payer               = "BucketOwner"
    tags                        = {}
    tags_all                    = {}

    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = true

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled    = false
        mfa_delete = false
    }

}

resource "aws_s3_bucket_object" "leadgen_data_storage_object" {
  key                    = "${local.env}/${local.version}/DynamoDBExport/calls-history/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}

resource "aws_s3_bucket_object" "leadgen_data_storage_sessions_object" {
  key                    = "${local.env}/${local.version}/DynamoDBExport/sessions/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}

resource "aws_s3_bucket_object" "leadgen_data_storage_ctrfirehose_object" {
  key                    = "${local.env}/${local.version}/KinesisFirehose/contact-trace-records/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}
resource "aws_s3_bucket_object" "leadgen_data_storage_agent_statusfirehose_object" {
  key                    = "${local.env}/${local.version}/KinesisFirehose/agent-status/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}
resource "aws_s3_bucket_object" "leadgen_data_storage_phone_tablefirehose_object" {
  key                    = "${local.env}/${local.version}/KinesisFirehose/phone-table/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}
resource "aws_s3_bucket_object" "leadgen_data_storage_session_tablefirehose_object" {
  key                    = "${local.env}/${local.version}/KinesisFirehose/session-table/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}

resource "aws_s3_bucket_object" "leadgen_data_storage_cft_object" {
  key                    = "${local.env}/${local.version}/CloudFormation/"
  bucket                 = aws_s3_bucket.leadgen_data_storage.id

}

resource "aws_s3_bucket" "leadgen_hosting_bucket" {
    bucket                      = "leadgen-${local.env}-hosting-bucket"
    object_lock_enabled         = false

    request_payer               = "BucketOwner"
    tags                        = {}
    tags_all                    = {}
    grant {
        id          = "932d530e9c0a0eb0229c8e5d57ecb845341507a8d5da531ead1ece32e8aa4e42"
        permissions = [
            "FULL_CONTROL",
        ]
        type        = "CanonicalUser"
    }
    grant {
        id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        permissions = [
            "FULL_CONTROL",
        ]
        type        = "CanonicalUser"
    }


    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = true

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled    = false
        mfa_delete = false
    }

}

resource "aws_s3_bucket_object" "leadgen_hosting_bucket_object" {
  key                    = "HostingSwapJS/"
  bucket                 = aws_s3_bucket.leadgen_hosting_bucket.id

}

resource "aws_s3_bucket" "leadgen_adhoc_bucket" {
    bucket                      = "leadgen-${local.env}-adhoc-bucket"                        
    object_lock_enabled         = false
    request_payer               = "BucketOwner"
    tags                        = {}
    tags_all                    = {}

    server_side_encryption_configuration {
        rule {
            bucket_key_enabled = true

            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled    = false
        mfa_delete = false
    }

}

resource "aws_s3_bucket_object" "leadgen_adhoc_bucket_object" {
  key                    = "athena-query-execution-results/"
  bucket                 = aws_s3_bucket.leadgen_adhoc_bucket.id

}