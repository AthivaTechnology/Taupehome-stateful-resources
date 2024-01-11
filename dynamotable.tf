resource "aws_dynamodb_table" "calls_history_agg" {
    billing_mode                = "PROVISIONED"
    deletion_protection_enabled = false
    hash_key                    = "pk"
    name                        = "${local.app}-calls-history-agg"
    range_key                   = "sk"
    read_capacity               = 1
    stream_enabled              = false
    table_class                 = "STANDARD"
    tags                        = {}
    tags_all                    = {}
    write_capacity              = 1

    attribute {
        name = "pk"
        type = "S"
    }
    attribute {
        name = "sk"
        type = "S"
    }

    point_in_time_recovery {
        enabled = false
    }

    ttl {
        attribute_name = "ttl"
        enabled        = true
    }

}

resource "aws_dynamodb_table" "calls_history" {
    billing_mode                = "PROVISIONED"
    deletion_protection_enabled = false
    hash_key                    = "pk"
    name                        = "${local.app}-calls-history"
    range_key                   = "sk"
    read_capacity               = 1
    stream_enabled              = true
    stream_view_type            = "NEW_AND_OLD_IMAGES"
    table_class                 = "STANDARD"
    tags                        = {}
    tags_all                    = {}
    write_capacity              = 1

    attribute {
        name = "pk"
        type = "S"
    }
    attribute {
        name = "sk"
        type = "S"
    }

    global_secondary_index {
        hash_key           = "pk"
        name               = "pk-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }
    global_secondary_index {
        hash_key           = "sk"
        name               = "sk-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }

    point_in_time_recovery {
        enabled = true
    }

}

resource "aws_lambda_event_source_mapping" "calls_history_table_lambda_trigger" {
  event_source_arn  = aws_dynamodb_table.calls_history.stream_arn
  function_name     = local.calls_history_lambda
  starting_position = "LATEST"
}

resource "aws_dynamodb_table" "dynamic_pools" {
    billing_mode                = "PROVISIONED"
    deletion_protection_enabled = false
    hash_key                    = "pk"
    name                        = "${local.app}-dynamic-pools"
    read_capacity               = 1
    stream_enabled              = false
    table_class                 = "STANDARD"
    tags                        = {
        "leadgen" = "version2"
    }
    tags_all                    = {
        "leadgen" = "version2"
    }
    write_capacity              = 1

    attribute {
        name = "pk"
        type = "S"
    }
    attribute {
        name = "swap_number"
        type = "S"
    }

    global_secondary_index {
        hash_key           = "swap_number"
        name               = "swap_number-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }

    point_in_time_recovery {
        enabled = false
    }

}

resource "aws_dynamodb_table" "phone_numbers" {
    billing_mode                = "PROVISIONED"
    deletion_protection_enabled = false
    hash_key                    = "pk"
    name                        = "${local.app}-phone-numbers"
    read_capacity               = 1
    stream_enabled              = true
    stream_view_type            = "NEW_AND_OLD_IMAGES"
    table_class                 = "STANDARD"
    tags                        = {
        "leadgen" = "version3"
    }
    tags_all                    = {
        "leadgen" = "version3"
    }
    write_capacity              = 1

    attribute {
        name = "pk"
        type = "S"
    }
    attribute {
        name = "session_id"
        type = "S"
    }
    attribute {
        name = "swap_number"
        type = "S"
    }
    attribute {
        name = "dynamic_pool_name"
        type = "S"
    }

    global_secondary_index {
        hash_key           = "session_id"
        name               = "session_id-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }
    global_secondary_index {
        hash_key           = "swap_number"
        name               = "swap_number-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }
    global_secondary_index {
        hash_key           = "dynamic_pool_name"
        name               = "dynamic_pool_name-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 1
        write_capacity     = 1
    }

    point_in_time_recovery {
        enabled = false
    }

}

resource "aws_dynamodb_table" "sessions" {
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = false
    hash_key                    = "pk"
    name                        = "${local.app}-sessions"
    range_key                   = "national_string"
    read_capacity               = 0
    stream_enabled              = true
    stream_view_type            = "NEW_AND_OLD_IMAGES"
    table_class                 = "STANDARD"
    tags                        = {}
    tags_all                    = {}
    write_capacity              = 0

    attribute {
        name = "national_string"
        type = "S"
    }
    attribute {
        name = "pk"
        type = "S"
    }

    global_secondary_index {
        hash_key           = "pk"
        name               = "pk-index"
        non_key_attributes = []
        projection_type    = "ALL"
        read_capacity      = 0
        write_capacity     = 0
    }

    point_in_time_recovery {
        enabled = true
    }

}

resource "aws_dynamodb_table" "sessions_audit_history" {
    billing_mode                = "PROVISIONED"
    deletion_protection_enabled = false
    hash_key                    = "session_id"
    name                        = "${local.app}-sessions-audit-history"
    range_key                   = "session_time"
    read_capacity               = 1
    stream_enabled              = true
    stream_view_type            = "NEW_AND_OLD_IMAGES"
    table_class                 = "STANDARD"
    tags                        = {}
    tags_all                    = {}
    write_capacity              = 1

    attribute {
        name = "session_id"
        type = "S"
    }
    attribute {
        name = "session_time"
        type = "S"
    }

    point_in_time_recovery {
        enabled = false
    }

}