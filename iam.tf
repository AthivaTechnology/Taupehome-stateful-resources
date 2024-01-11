resource "aws_iam_role" "kinesis_firehose_session_audit_service_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "firehose.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [ aws_iam_policy.kinesis_firehose_session_audit_service_role_policy.arn
      ]
    max_session_duration  = 3600
    name                  = "${local.app}-kinesis_firehose_session_audit_service_role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "kinesis_firehose_session_audit_service_role_policy" {
    name      = "${local.app}-kinesis_firehose_session_audit_service_role_policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "glue:GetTable",
                        "glue:GetTableVersion",
                        "glue:GetTableVersions",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:glue:${local.region}:${local.account_id}:catalog",
                        "arn:aws:glue:${local.region}:${local.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                        "arn:aws:glue:${local.region}:${local.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka:GetBootstrapBrokers",
                        "kafka:DescribeCluster",
                        "kafka:DescribeClusterV2",
                        "kafka-cluster:Connect",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeTopic",
                        "kafka-cluster:DescribeTopicDynamicConfiguration",
                        "kafka-cluster:ReadData",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeGroup",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    Sid      = ""
                },
                {
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::${local.data_s3_bucket}",
                        "arn:aws:s3:::${local.data_s3_bucket}/*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                        "lambda:GetFunctionConfiguration",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:lambda:${local.region}:${local.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:GenerateDataKey",
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "s3.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:s3:arn" = [
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
                {
                    Action   = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:CreateLogGroup"                        
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/sessions-audit-firehose:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "kinesis.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}

resource "aws_iam_role" "kinesis_firehose_phone_number_audit_service_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "firehose.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [ aws_iam_policy.kinesis_firehose_phone_number_audit_service_role_policy.arn
      ]
    max_session_duration  = 3600
    name                  = "${local.app}-kinesis_firehose_phone_number_audit_service_role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "kinesis_firehose_phone_number_audit_service_role_policy" {
    name      = "${local.app}-kinesis_firehose_phone_number_audit_service_role_policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "glue:GetTable",
                        "glue:GetTableVersion",
                        "glue:GetTableVersions",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:glue:${local.region}:${local.account_id}:catalog",
                        "arn:aws:glue:${local.region}:${local.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                        "arn:aws:glue:${local.region}:${local.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka:GetBootstrapBrokers",
                        "kafka:DescribeCluster",
                        "kafka:DescribeClusterV2",
                        "kafka-cluster:Connect",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeTopic",
                        "kafka-cluster:DescribeTopicDynamicConfiguration",
                        "kafka-cluster:ReadData",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeGroup",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    Sid      = ""
                },
                {
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::${local.data_s3_bucket}",
                        "arn:aws:s3:::${local.data_s3_bucket}/*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                        "lambda:GetFunctionConfiguration",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:lambda:${local.region}:${local.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:GenerateDataKey",
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "s3.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:s3:arn" = [
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
                {
                    Action   = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:CreateLogGroup",
                        "logs:DescribeLogStreams",
                        "logs:DescribeLogGroups"   
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:firehose:${local.region}:${local.account_id}:deliverystream/phone-number-audit-firehose",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/phone-number-audit-firehose:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "kinesis.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}

resource "aws_iam_role" "kinesis_agent_status_service_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "firehose.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [ aws_iam_policy.kinesis_agent_status_policy.arn
      ]
    max_session_duration  = 3600
    name                  = "${local.app}-kinesis_firehose_agent_status_service_role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "kinesis_agent_status_policy" {
    name      = "${local.app}-firehose-agent-status-policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "glue:GetTable",
                        "glue:GetTableVersion",
                        "glue:GetTableVersions",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:glue:${local.region}:${local.account_id}:catalog",
                        "arn:aws:glue:${local.region}:${local.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                        "arn:aws:glue:${local.region}:${local.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka:GetBootstrapBrokers",
                        "kafka:DescribeCluster",
                        "kafka:DescribeClusterV2",
                        "kafka-cluster:Connect",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeTopic",
                        "kafka-cluster:DescribeTopicDynamicConfiguration",
                        "kafka-cluster:ReadData",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeGroup",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    Sid      = ""
                },
                {
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::${local.data_s3_bucket}",
                        "arn:aws:s3:::${local.data_s3_bucket}/*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                        "lambda:GetFunctionConfiguration",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:lambda:${local.region}:${local.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:GenerateDataKey",
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "s3.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:s3:arn" = [
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
                {
                    Action   = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:CreateLogGroup"   
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/agent-status:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:kinesis:${local.region}:${local.account_id}:stream/ctr-processor",
                        "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    ]
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "kinesis.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}


resource "aws_iam_role" "kinesis_firehose_contact_trace_records_service_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "firehose.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [ aws_iam_policy.kinesis_firehose_contact_trace_records_service_role_policy.arn
      ]
    max_session_duration  = 3600
    name                  = "${local.app}-kinesis_firehose_contact_trace_records_service_role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "kinesis_firehose_contact_trace_records_service_role_policy" {
    name      = "${local.app}-kinesis_firehose_contact_trace_records_service_role_policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "glue:GetTable",
                        "glue:GetTableVersion",
                        "glue:GetTableVersions",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:glue:${local.region}:${local.account_id}:catalog",
                        "arn:aws:glue:${local.region}:${local.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                        "arn:aws:glue:${local.region}:${local.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka:GetBootstrapBrokers",
                        "kafka:DescribeCluster",
                        "kafka:DescribeClusterV2",
                        "kafka-cluster:Connect",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeTopic",
                        "kafka-cluster:DescribeTopicDynamicConfiguration",
                        "kafka-cluster:ReadData",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeGroup",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    Sid      = ""
                },
                {
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::${local.data_s3_bucket}",
                        "arn:aws:s3:::${local.data_s3_bucket}/*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                        "lambda:GetFunctionConfiguration",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:lambda:${local.region}:${local.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:GenerateDataKey",
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "s3.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:s3:arn" = [
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
                {
                    Action   = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:CreateLogGroup"   
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/contact-trace-records-firehose:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/ctr-processor-contact:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards",
                    ]
                    Effect   = "Allow"
                    Resource = [
                    "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    "arn:aws:kinesis:${local.region}:${local.account_id}:stream/ctr-processor-contact"
                    ]
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "kinesis.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}

resource "aws_iam_role" "kinesis_firehose_sessions_audit_history_service_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "firehose.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [ aws_iam_policy.kinesis_firehose_sessions_audit_history_service_role_policy.arn
      ]
    max_session_duration  = 3600
    name                  = "${local.app}-kinesis_firehose_sessions_audit_history_service_role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "kinesis_firehose_sessions_audit_history_service_role_policy" {
    name      = "${local.app}-kinesis_firehose_sessions_audit_history_service_role_policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "glue:GetTable",
                        "glue:GetTableVersion",
                        "glue:GetTableVersions",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:glue:${local.region}:${local.account_id}:catalog",
                        "arn:aws:glue:${local.region}:${local.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                        "arn:aws:glue:${local.region}:${local.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka:GetBootstrapBrokers",
                        "kafka:DescribeCluster",
                        "kafka:DescribeClusterV2",
                        "kafka-cluster:Connect",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeTopic",
                        "kafka-cluster:DescribeTopicDynamicConfiguration",
                        "kafka-cluster:ReadData",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action   = [
                        "kafka-cluster:DescribeGroup",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kafka:${local.region}:${local.account_id}:group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    Sid      = ""
                },
                {
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:s3:::${local.data_s3_bucket}",
                        "arn:aws:s3:::${local.data_s3_bucket}/*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                        "lambda:GetFunctionConfiguration",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:lambda:${local.region}:${local.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:GenerateDataKey",
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "s3.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:s3:arn" = [
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                                "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
                {
                    Action   = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:CreateLogGroup"   
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesisfirehose/sessions-audit-history-firehose:log-stream:*",
                        "arn:aws:logs:${local.region}:${local.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
                    ]
                    Sid      = ""
                },
                {
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    Sid      = ""
                },
                {
                    Action    = [
                        "kms:Decrypt",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:ViaService" = "kinesis.${local.region}.amazonaws.com"
                        }
                        StringLike   = {
                            "kms:EncryptionContext:aws:kinesis:arn" = "arn:aws:kinesis:${local.region}:${local.account_id}:stream/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:aws:kms:${local.region}:${local.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}

# Cognito Roles and Policies

resource "aws_iam_role" "cognito_api_auth_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "cognito-idp.amazonaws.com"
                    }
                    Sid       = ""
                },
                {
                    Action    = "sts:AssumeRoleWithWebIdentity"
                    Condition = {
                        "ForAnyValue:StringLike" = {
                            "cognito-identity.amazonaws.com:amr" = "authenticated"
                        }
                        StringEquals             = {
                            "cognito-identity.amazonaws.com:aud" = "${local.identity_pool_id}"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Federated = "cognito-identity.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        aws_iam_policy.cognito_api_auth_policy.arn
    ]
    max_session_duration  = 3600
    name                  = "${local.app}-cognito-api-auth"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}

}

resource "aws_iam_policy" "cognito_api_auth_policy" {
    name      = "${local.app}-cognito_api_auth_policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "sns:publish",
                        "sts:AssumeRoleWithWebIdentity",
                        "quicksight:RegisterUser",
                        "quicksight:GenerateEmbedUrlForAnonymousUser",
                        "quicksight:GenerateEmbedUrlForRegisteredUser",
                        "quicksight:GetDashboardEmbedUrl",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "*",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}


resource "aws_iam_role" "auth_seperation_identitypool_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRoleWithWebIdentity"
                    Condition = {
                        "ForAnyValue:StringLike" = {
                            "cognito-identity.amazonaws.com:amr" = "authenticated"
                        }
                        StringEquals             = {
                            "cognito-identity.amazonaws.com:aud" = "${local.region}:${local.cognito_user_pool_id_value}"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Federated = "cognito-identity.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    managed_policy_arns   = [
        aws_iam_policy.auth_seperation_identitypool_policy.arn
    ]
    max_session_duration  = 3600
    name                  = "${local.app}-auth-seperation-identitypool-role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "auth_seperation_identitypool_policy" {
    name      = "${local.app}-auth-seperation-identitypool-policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "execute-api:Invoke",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:execute-api:${local.region}:${local.account_id}:415zsw3m7h/Stage/GET/getdashboardurlembed/*",
                        "arn:aws:execute-api:${local.region}:${local.account_id}:415zsw3m7h/Stage/GET/getdashboardurlembed",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}

}

# Amazon EventBridge Pipe Roles and Policies 

resource "aws_iam_role" "eventbridge_pipe_exec_role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Condition = {
                        StringEquals = {
                            "aws:SourceAccount" = local.account_id
                            "aws:SourceArn"     = [
                                "arn:aws:pipes:${local.region}:${local.account_id}:pipe/phone-number-audit-firehose-pipe",
                                "arn:aws:pipes:${local.region}:${local.account_id}:pipe/session-audit-firehose-pipe",
                                "arn:aws:pipes:${local.region}:${local.account_id}:pipe/sessions-audit-history-firehose-pipe"

                            ]
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        Service = "pipes.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    # managed_policy_arns   = [
    #     "arn:aws:iam::${local.account_id}:policy/service-role/dynamodb-pipe-policy",
    #     "arn:aws:iam::${local.account_id}:policy/service-role/firehose-pipe-policy"
    # ]
    max_session_duration  = 3600
    name                  = "${local.app}-eventbridge-pipe-exec-role"
    path                  = "/service-role/"
    tags                  = {}
    tags_all              = {}
}

resource "aws_iam_policy" "dynamodb_pipe_policy" {
    name      = "${local.app}-dynamodb-pipe-policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "dynamodb:DescribeStream",
                        "dynamodb:GetRecords",
                        "dynamodb:GetShardIterator",
                        "dynamodb:ListStreams",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        aws_dynamodb_table.phone_numbers.stream_arn,
                        aws_dynamodb_table.sessions.stream_arn,
                        aws_dynamodb_table.sessions_audit_history.stream_arn
                        # "arn:aws:dynamodb:${local.region}:${local.account_id}:table/phone-numbers/stream/2023-11-21T14:10:20.191",
                        # "arn:aws:dynamodb:${local.region}:${local.account_id}:table/sessions/stream/2023-11-21T14:10:18.077",
                        # "arn:aws:dynamodb:${local.region}:${local.account_id}:table/sessions-audit-history/stream/2023-11-21T14:10:18.123"
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}
}

resource "aws_iam_policy" "firehose_pipe_policy" {
    name      = "${local.app}-firehose-pipe-policy"
    path      = "/service-role/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "firehose:PutRecord",
                        "firehose:PutRecordBatch",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:firehose:${local.region}:${local.account_id}:deliverystream/phone-number-audit-firehose",
                        "arn:aws:firehose:${local.region}:${local.account_id}:deliverystream/sessions-audit-firehose",
                        "arn:aws:firehose:${local.region}:${local.account_id}:deliverystream/sessions-audit-history-firehose"
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_pipe_policy" {
  policy_arn = aws_iam_policy.dynamodb_pipe_policy.arn
  role       = aws_iam_role.eventbridge_pipe_exec_role.name
}

resource "aws_iam_role_policy_attachment" "attach_firehose_pipe_policy" {
  policy_arn = aws_iam_policy.firehose_pipe_policy.arn
  role       = aws_iam_role.eventbridge_pipe_exec_role.name
}