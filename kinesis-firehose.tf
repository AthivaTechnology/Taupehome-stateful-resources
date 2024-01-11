# AGENT STATUS FIREHOSE

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "agent_cloudwatch_log_group" {
  name = "/aws/${local.app}/kinesisfirehose/agent-status-firehose"
}

# Create CloudWatch Log Streams
resource "aws_cloudwatch_log_stream" "agent_cloudwatch_log_stream_destination" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.agent_cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "agent_cloudwatch_log_stream_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.agent_cloudwatch_log_group.name
}

resource "aws_kinesis_firehose_delivery_stream" "agent_status_firehose" {
    destination    = "extended_s3"
    name           = "${local.app}-agent-status-firehose"
    tags           = {}
    tags_all       = {}

    extended_s3_configuration {
        bucket_arn          = aws_s3_bucket.leadgen_data_storage.arn
        buffering_interval  = 60
        buffering_size      = 128
        compression_format  = "UNCOMPRESSED"
        error_output_prefix = "${local.env}/${local.version}/KinesisFirehose/agent-status/fherroroutputbase-error/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyy/MM/dd}/"
        prefix              = "${local.env}/${local.version}/KinesisFirehose/agent-status/fhbase/!{partitionKeyFromQuery:PartitionDateTimePrefix}/"
        role_arn            = aws_iam_role.kinesis_agent_status_service_role.arn
        s3_backup_mode      = "Disabled"

        cloudwatch_logging_options {
            enabled         = true
            log_group_name  = aws_cloudwatch_log_group.agent_cloudwatch_log_group.name
            log_stream_name = aws_cloudwatch_log_stream.agent_cloudwatch_log_stream_destination.name
        }

        dynamic_partitioning_configuration {
            enabled        = true
            retry_duration = 300
        }

        processing_configuration {
            enabled = true

            processors {
                type = "AppendDelimiterToRecord"
            }
            processors {
                type = "MetadataExtraction"

                parameters {
                    parameter_name  = "MetadataExtractionQuery"
                    parameter_value = "{PartitionDateTimePrefix:(.EventTimestamp[0:19] + \"Z\")| fromdateiso8601| strftime(\"year=%Y/month=%m/day=%d\")}"
                }
                parameters {
                    parameter_name  = "JsonParsingEngine"
                    parameter_value = "JQ-1.6"
                }
            }
        }
    }

    kinesis_source_configuration {
        kinesis_stream_arn = local.agent_events
        role_arn           = aws_iam_role.kinesis_agent_status_service_role.arn
    }


}

# PHONE NUMBER AUDIT FIREHOSE

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "phone_audit_cloudwatch_log_group" {
  name = "/aws/${local.app}/kinesisfirehose/phone-number-audit-firehose"
}

# Create CloudWatch Log Streams
resource "aws_cloudwatch_log_stream" "phone_audit_cloudwatch_log_stream_destination" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.phone_audit_cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "phone_audit_cloudwatch_log_stream_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.phone_audit_cloudwatch_log_group.name
}

resource "aws_kinesis_firehose_delivery_stream" "phone_number_audit_firehose" {
    destination    = "extended_s3"
    name           = "${local.app}-phone-number-audit-firehose"
    tags           = {}
    tags_all       = {}

    extended_s3_configuration {
        bucket_arn          = aws_s3_bucket.leadgen_data_storage.arn
        buffering_interval  = 60
        buffering_size      = 128
        compression_format  = "UNCOMPRESSED"
        error_output_prefix = "${local.env}/${local.version}/KinesisFirehose/phone-table/fherroroutputbase-error/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyy/MM/dd}/"
        prefix              = "${local.env}/${local.version}/KinesisFirehose/phone-table/fhbase/year=!{partitionKeyFromQuery:year}/month=!{partitionKeyFromQuery:month}/day=!{partitionKeyFromQuery:day}/"
        role_arn            = aws_iam_role.kinesis_firehose_phone_number_audit_service_role.arn
        s3_backup_mode      = "Disabled"

        cloudwatch_logging_options {
            enabled         = true
            log_group_name  = aws_cloudwatch_log_group.phone_audit_cloudwatch_log_group.name
            log_stream_name = aws_cloudwatch_log_stream.phone_audit_cloudwatch_log_stream_destination.name
        }

        dynamic_partitioning_configuration {
            enabled        = true
            retry_duration = 300
        }

        processing_configuration {
            enabled = true

            processors {
                type = "AppendDelimiterToRecord"
            }
            processors {
                type = "MetadataExtraction"

                parameters {
                    parameter_name  = "MetadataExtractionQuery"
                    parameter_value = "{year:.dynamodb.ApproximateCreationDateTime | strftime(\"%Y\"),month:.dynamodb.ApproximateCreationDateTime | strftime(\"%m\"),day:.dynamodb.ApproximateCreationDateTime | strftime(\"%d\")}"
                }
                parameters {
                    parameter_name  = "JsonParsingEngine"
                    parameter_value = "JQ-1.6"
                }
            }
        }
    }
}

# SESSIONS AUDIT FIREHOSE

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "sessions_audit_cloudwatch_log_group" {
  name = "/aws/${local.app}/kinesisfirehose/sessions-audit-firehose"
}

# Create CloudWatch Log Streams
resource "aws_cloudwatch_log_stream" "sessions_audit_cloudwatch_log_stream_destination" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.sessions_audit_cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "sessions_audit_cloudwatch_log_stream_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.sessions_audit_cloudwatch_log_group.name
}

resource "aws_kinesis_firehose_delivery_stream" "sessions_audit_firehose" {
    destination    = "extended_s3"
    name           = "${local.app}-sessions-audit-firehose"
    tags           = {}
    tags_all       = {}

    extended_s3_configuration {
        bucket_arn          = aws_s3_bucket.leadgen_data_storage.arn
        buffering_interval  = 60
        buffering_size      = 128
        compression_format  = "UNCOMPRESSED"
        error_output_prefix = "${local.env}/${local.version}/KinesisFirehose/session-table/fherroroutputbase-error/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyy/MM/dd}/"
        prefix              = "${local.env}/${local.version}/KinesisFirehose/session-table/fhbase/year=!{partitionKeyFromQuery:year}/month=!{partitionKeyFromQuery:month}/day=!{partitionKeyFromQuery:day}/"
        role_arn            = aws_iam_role.kinesis_firehose_session_audit_service_role.arn
        s3_backup_mode      = "Disabled"

        cloudwatch_logging_options {
            enabled         = true
            log_group_name  = aws_cloudwatch_log_group.sessions_audit_cloudwatch_log_group.name
            log_stream_name = aws_cloudwatch_log_stream.sessions_audit_cloudwatch_log_stream_destination.name
        }

        dynamic_partitioning_configuration {
            enabled        = true
            retry_duration = 300
        }

        processing_configuration {
            enabled = true

            processors {
                type = "AppendDelimiterToRecord"
            }
            processors {
                type = "MetadataExtraction"

                parameters {
                    parameter_name  = "MetadataExtractionQuery"
                    parameter_value = "{year:.dynamodb.ApproximateCreationDateTime | strftime(\"%Y\"),month:.dynamodb.ApproximateCreationDateTime | strftime(\"%m\"),day:.dynamodb.ApproximateCreationDateTime | strftime(\"%d\")}"
                }
                parameters {
                    parameter_name  = "JsonParsingEngine"
                    parameter_value = "JQ-1.6"
                }
            }
        }
    }
}

# CONTACT TRACE RECORDS FIREHOSE

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "contact_trace_records_cloudwatch_log_group" {
  name = "/aws/${local.app}/kinesisfirehose/contact-trace-records"
}

# Create CloudWatch Log Streams
resource "aws_cloudwatch_log_stream" "contact_trace_records_cloudwatch_log_stream_destination" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.contact_trace_records_cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "contact_trace_records_cloudwatch_log_stream_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.contact_trace_records_cloudwatch_log_group.name
}

resource "aws_kinesis_firehose_delivery_stream" "contact_trace_records_firehose" {
    destination    = "extended_s3"
    name           = "${local.app}-contact-trace-records-firehose"
    tags           = {}
    tags_all       = {}

    extended_s3_configuration {
        bucket_arn          = aws_s3_bucket.leadgen_data_storage.arn
        buffering_interval  = 60
        buffering_size      = 128
        compression_format  = "UNCOMPRESSED"
        error_output_prefix = "${local.env}/${local.version}/KinesisFirehose/contact-trace-records/fherroroutputbase-error/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyy/MM/dd}/"
        prefix              = "${local.env}/${local.version}/KinesisFirehose/contact-trace-records/fhbase/!{partitionKeyFromQuery:PartitionDateTimePrefix}/"
        role_arn            = aws_iam_role.kinesis_firehose_contact_trace_records_service_role.arn
        s3_backup_mode      = "Disabled"

        cloudwatch_logging_options {
            enabled         = true
            log_group_name  = aws_cloudwatch_log_group.contact_trace_records_cloudwatch_log_group.name
            log_stream_name = aws_cloudwatch_log_stream.contact_trace_records_cloudwatch_log_stream_destination.name
        }

        dynamic_partitioning_configuration {
            enabled        = true
            retry_duration = 300
        }

        processing_configuration {
            enabled = true

            processors {
                type = "AppendDelimiterToRecord"
            }
            processors {
                type = "MetadataExtraction"

                parameters {
                    parameter_name  = "MetadataExtractionQuery"
                    parameter_value = "{PartitionDateTimePrefix:.InitiationTimestamp| fromdateiso8601| strftime(\"year=%Y/month=%m/day=%d\")}"
                }
                parameters {
                    parameter_name  = "JsonParsingEngine"
                    parameter_value = "JQ-1.6"
                }
            }
        }
    }

    kinesis_source_configuration {
        kinesis_stream_arn = local.ctr_processor
        role_arn           = aws_iam_role.kinesis_firehose_contact_trace_records_service_role.arn
    }
}


# SESSIONS AUDIT HISTORY FIREHOSE

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "sessions_audit_history_cloudwatch_log_group" {
  name = "/aws/${local.app}/kinesisfirehose/sessions_audit_history_firehose"
}

# Create CloudWatch Log Streams
resource "aws_cloudwatch_log_stream" "sessions_audit_history_cloudwatch_log_stream_destination" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.sessions_audit_history_cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "sessions_audit_history_cloudwatch_log_stream_backup" {
  name           = "BackupDelivery"
  log_group_name = aws_cloudwatch_log_group.sessions_audit_history_cloudwatch_log_group.name
}

resource "aws_kinesis_firehose_delivery_stream" "sessions_audit_history_firehose" {
    destination    = "extended_s3"
    name           = "${local.app}-sessions-audit-history-firehose"
    tags           = {}
    tags_all       = {}

    extended_s3_configuration {
        bucket_arn          = aws_s3_bucket.leadgen_data_storage.arn
        buffering_interval  = 60
        buffering_size      = 128
        compression_format  = "UNCOMPRESSED"
        error_output_prefix = "${local.env}/${local.version}/KinesisFirehose/sessions-audit-history/fherroroutputbase-error/!{firehose:random-string}/!{firehose:error-output-type}/!{timestamp:yyy/MM/dd}/"
        prefix              = "${local.env}/${local.version}/KinesisFirehose/sessions-audit-history/fhbase/year=!{partitionKeyFromQuery:year}/month=!{partitionKeyFromQuery:month}/day=!{partitionKeyFromQuery:day}/"
        role_arn            = aws_iam_role.kinesis_firehose_sessions_audit_history_service_role.arn
        s3_backup_mode      = "Disabled"

        cloudwatch_logging_options {
            enabled         = true
            log_group_name  = aws_cloudwatch_log_group.sessions_audit_history_cloudwatch_log_group.name
            log_stream_name = aws_cloudwatch_log_stream.sessions_audit_history_cloudwatch_log_stream_destination.name
        }

        dynamic_partitioning_configuration {
            enabled        = true
            retry_duration = 300
        }

        processing_configuration {
            enabled = true

            processors {
                type = "AppendDelimiterToRecord"
            }
            processors {
                type = "MetadataExtraction"

                parameters {
                    parameter_name  = "MetadataExtractionQuery"
                    parameter_value = "{year:.dynamodb.ApproximateCreationDateTime | strftime(\"%Y\"),month:.dynamodb.ApproximateCreationDateTime | strftime(\"%m\"),day:.dynamodb.ApproximateCreationDateTime | strftime(\"%d\")}"
                }
                parameters {
                    parameter_name  = "JsonParsingEngine"
                    parameter_value = "JQ-1.6"
                }
            }
        }
    }
}
