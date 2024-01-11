resource "aws_pipes_pipe" "phone_number_audit_firehose_pipe" {
    desired_state = "RUNNING"
    name          = "${local.app}-phone-number-audit-firehose-pipe"
    role_arn      = aws_iam_role.eventbridge_pipe_exec_role.arn
    source        = aws_dynamodb_table.phone_numbers.stream_arn
    target        = aws_kinesis_firehose_delivery_stream.phone_number_audit_firehose.arn
    source_parameters {

        dynamodb_stream_parameters {
            batch_size                         = 1
            starting_position                  = "LATEST"
        }
    }
}

resource "aws_pipes_pipe" "session_audit_firehose_pipe" {
    desired_state = "RUNNING"
    name          = "${local.app}-session-audit-firehose-pipe"
    role_arn      = aws_iam_role.eventbridge_pipe_exec_role.arn
    source        = aws_dynamodb_table.sessions.stream_arn
    target        = aws_kinesis_firehose_delivery_stream.sessions_audit_firehose.arn
    source_parameters {

        dynamodb_stream_parameters {
            batch_size                         = 1
            starting_position                  = "LATEST"
        }
    }
}

resource "aws_pipes_pipe" "session_audit_history_firehose_pipe" {
    desired_state = "RUNNING"
    name          = "${local.app}-sessions-audit-history-firehose-pipe"
    role_arn      = aws_iam_role.eventbridge_pipe_exec_role.arn
    source        = aws_dynamodb_table.sessions_audit_history.stream_arn
    target        = aws_kinesis_firehose_delivery_stream.sessions_audit_history_firehose.arn

    source_parameters {

        dynamodb_stream_parameters {
            batch_size                         = 1
            starting_position                  = "LATEST"
        }
    }

}