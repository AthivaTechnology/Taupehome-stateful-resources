data "aws_kinesis_stream" "existing_ctr_processor_contact_kinesis_stream" {
  name = "ctr-processor-contact"
}

data "aws_kinesis_stream" "existing_ctr_processor_kinesis_stream" {
  name = "ctr-processor"
}

resource "aws_kinesis_stream" "agent_status_stream" {
    encryption_type     = "NONE"
    name                = "agent-status"
    retention_period    = 24
    shard_count         = 1
    shard_level_metrics = []
    tags                = {}
    tags_all            = {}

    stream_mode_details {
        stream_mode = "PROVISIONED"
    }
}

