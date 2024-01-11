resource "aws_glue_catalog_table" "calls_history_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-calls_history_catalog_table"
    owner         = "hadoop"
    parameters    = {
        "classification"                   = "ion"
        "compressionType"                  = "gzip"
        "partition_filtering.enabled"      = "true"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "com.amazon.ionhiveserde.formats.IonInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/DynamoDBExport/calls-history/calls-history-full-export-data/"
        number_of_buckets         = -1
        output_format             = "com.amazon.ionhiveserde.formats.IonOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            name       = "item"
            parameters = {}
            type       = "struct<pk:string,sk:string,call_time:string,forwarded_to:string,dynamic_pool_name:string,status:string,country:string,city:string,session_start_time:string,referrer:string,session_attributes:struct<country:string,ip:string,session_start_time:string,device_type:string,swaps:array<string>,uuid:string,all_formats:boolean,ref:string,landing:string,location_details:struct<country:string,region:string,city:string,ip:string>,google_content_cookies:string,device_information:string,parsed_useragent:struct<os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,string:string,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,ids:array<decimal(38,18)>,record_pageview:boolean,perf:struct<dns:decimal(38,18),conn:decimal(38,18),tls:decimal(38,18),wait:decimal(38,18),recv:decimal(38,18)>,location_information:string,user_agent:string,cid:string>,session_id:string,swap_number:string,routing_profile:string,device_information:string,family:string,region:string,device_info:struct<string:string,os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,states_change_info:array<struct<state:string,state_start_time:string,agent_arn:string,username:string>>,phno_type:string,agent_arn:string,swap_number_cc:string,landing:string,last_name:string,first_name:string,ip_location:struct<country:string,region:string,city:string,ip:string>,major:string,username:string,campaign_info:string,location_information:string,call_duration_seconds:decimal(38,18),phno_description:string>"
        }

        ser_de_info {
            parameters            = {
                "serialization.format" = "1"
            }
            serialization_library = "com.amazon.ionhiveserde.IonHiveSerDe"
        }
    }

}

resource "aws_glue_catalog_table" "contact_trace_records_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-contact_trace_records_catalog_table"
    owner         = "hadoop"
    parameters    = {
        "partition_filtering.enabled"      = "true"
        "projection.day.digits"            = "2"
        "projection.day.interval"          = "1"
        "projection.day.range"             = "1,31"
        "projection.day.type"              = "integer"
        "projection.enabled"               = "true"
        "projection.month.digits"          = "2"
        "projection.month.interval"        = "1"
        "projection.month.range"           = "1,12"
        "projection.month.type"            = "integer"
        "projection.year.digits"           = "4"
        "projection.year.interval"         = "1"
        "projection.year.range"            = "2023,2025"
        "projection.year.type"             = "integer"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    partition_keys {
        name = "year"
        type = "string"
    }
    partition_keys {
        name = "month"
        type = "string"
    }
    partition_keys {
        name = "day"
        type = "string"
    }

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "org.apache.hadoop.mapred.TextInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/KinesisFirehose/contact-trace-records/fhbase/"
        number_of_buckets         = -1
        output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            comment    = "from deserializer"
            name       = "awsaccountid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "awscontacttracerecordformatversion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "agent"
            parameters = {}
            type       = "struct<arn:string,aftercontactworkduration:int,aftercontactworkendtimestamp:string,aftercontactworkstarttimestamp:string,agentinteractionduration:int,connectedtoagenttimestamp:string,customerholdduration:int,hierarchygroups:string,longestholdduration:int,numberofholds:int,routingprofile:struct<arn:string,name:string>,statetransitions:string,username:string,agentpausedurationinseconds:int>"
        }
        columns {
            comment    = "from deserializer"
            name       = "agentconnectionattempts"
            parameters = {}
            type       = "int"
        }
        columns {
            comment    = "from deserializer"
            name       = "answeringmachinedetectionstatus"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "attributes"
            parameters = {}
            type       = "struct<callreason:string,greetingplayed:string,disconnectflowrun:string,intro:string,loopcounter:string,outro:string,surveyid:string,surveysize:string,survey_result_1:string,survey_result_2:string,flowname:string,flowid:string,response:string,flow_id:string,id:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "campaign"
            parameters = {}
            type       = "struct<campaignid:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "channel"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "connectedtosystemtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "contactdetails"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "contactid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "customerendpoint"
            parameters = {}
            type       = "struct<address:string,type:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "disconnectreason"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "disconnecttimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "initialcontactid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "initiationmethod"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "initiationtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "instancearn"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "lastupdatetimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "mediastreams"
            parameters = {}
            type       = "array<struct<type:string>>"
        }
        columns {
            comment    = "from deserializer"
            name       = "nextcontactid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "previouscontactid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "queue"
            parameters = {}
            type       = "struct<arn:string,dequeuetimestamp:string,duration:int,enqueuetimestamp:string,name:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "recording"
            parameters = {}
            type       = "struct<deletionreason:string,location:string,status:string,type:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "recordings"
            parameters = {}
            type       = "array<struct<deletionreason:string,fragmentstartnumber:string,fragmentstopnumber:string,location:string,mediastreamtype:string,participanttype:string,starttimestamp:string,status:string,stoptimestamp:string,storagetype:string>>"
        }
        columns {
            comment    = "from deserializer"
            name       = "references"
            parameters = {}
            type       = "array<string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "scheduledtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "systemendpoint"
            parameters = {}
            type       = "struct<address:string,type:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "tags"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "transfercompletedtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "transferredtoendpoint"
            parameters = {}
            type       = "struct<address:string,type:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "voiceidresult"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "contactevaluations"
            parameters = {}
            type       = "struct<evaluationarn:struct<deletetimestamp:string,endtimestamp:string,evaluationarn:string,exportlocation:string,formid:string,starttimestamp:string,status:string>>"
        }
        columns {
            comment    = "from deserializer"
            name       = "lastpausedtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "lastresumedtimestamp"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "totalpausecount"
            parameters = {}
            type       = "int"
        }
        columns {
            comment    = "from deserializer"
            name       = "totalpausedurationinseconds"
            parameters = {}
            type       = "int"
        }

        ser_de_info {
            parameters            = {
                "paths"                = "AWSAccountId,AWSContactTraceRecordFormatVersion,Agent,AgentConnectionAttempts,AnsweringMachineDetectionStatus,Attributes,Campaign,Channel,ConnectedToSystemTimestamp,ContactDetails,ContactEvaluations,ContactId,CustomerEndpoint,DisconnectReason,DisconnectTimestamp,InitialContactId,InitiationMethod,InitiationTimestamp,InstanceARN,LastPausedTimestamp,LastResumedTimestamp,LastUpdateTimestamp,MediaStreams,NextContactId,PreviousContactId,Queue,Recording,Recordings,References,ScheduledTimestamp,SystemEndpoint,Tags,TotalPauseCount,TotalPauseDurationInSeconds,TransferCompletedTimestamp,TransferredToEndpoint,VoiceIdResult"
                "serialization.format" = "1"
            }
            serialization_library = "org.openx.data.jsonserde.JsonSerDe"
        }

    }

}

resource "aws_glue_catalog_table" "sessions_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-sessions_catalog_table"
    owner         = "hadoop"
    parameters    = {
        "EXTERNAL"              = "TRUE"
        "classification"        = "ion"
        "compressionType"       = "gzip"
        # "transient_lastDdlTime" = "1701240921"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "com.amazon.ionhiveserde.formats.IonInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/DynamoDBExport/sessions/sessions-full-export-data"
        number_of_buckets         = -1
        output_format             = "com.amazon.ionhiveserde.formats.IonOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            name       = "item"
            parameters = {}
            type       = "struct<national_string:string,pk:string,session_start_time:string,session_attributes:struct<country:string,ip:string,session_start_time:string,device_type:string,swaps:array<string>,uuid:string,all_formats:boolean,ref:string,landing:string,location_details:struct<country:string,region:string,city:string,ip:string>,google_content_cookies:string,device_information:string,parsed_useragent:struct<os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,string:string,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,ids:array<decimal(38,18)>,ga:string,record_pageview:boolean,perf:struct<dns:decimal(38,18),conn:decimal(38,18),tls:decimal(38,18),wait:decimal(38,18),recv:decimal(38,18)>,location_information:string,user_agent:string,cid:string>,session_refresh_time:string>"
        }

        ser_de_info {
            parameters            = {
                "serialization.format" = "1"
            }
            serialization_library = "com.amazon.ionhiveserde.IonHiveSerDe"
        }


    }

}


resource "aws_glue_catalog_table" "calls_history_org_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-calls_history_org_catalog_table"
    owner         = "hadoop"
    parameters    = {
        "classification"                   = "ion"
        "compressionType"                  = "gzip"

    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "com.amazon.ionhiveserde.formats.IonInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/DynamoDBExport/calls-history/calls-history-org-full-export-data/"
        number_of_buckets         = -1
        output_format             = "com.amazon.ionhiveserde.formats.IonOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            name       = "item"
            parameters = {}
            type       = "struct<pk:string,sk:string,call_time:string,phno_type:string,aws_connect_number:string,status:string,states_change_info:array<struct<state:string,state_start_time:string,agent_arn:string,username:string>>,last_name:string,first_name:string,agent_arn:string,routing_profile:string,username:string,campaign_info:string,call_duration_seconds:decimal(38,18),phno_description:string,device_info:struct<string:string,os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,forwarded_to:string,dynamic_pool_name:string,country:string,city:string,swap_number_cc:string,session_start_time:string,referrer:string,landing:string,session_attributes:struct<country:string,ip:string,session_start_time:string,device_type:string,swaps:array<string>,uuid:string,all_formats:boolean,ref:string,landing:string,location_details:struct<country:string,region:string,city:string,ip:string>,google_content_cookies:string,device_information:string,parsed_useragent:struct<os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,string:string,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,ids:array<decimal(38,18)>,record_pageview:boolean,perf:struct<dns:decimal(38,18),conn:decimal(38,18),tls:decimal(38,18),wait:decimal(38,18),recv:decimal(38,18)>,location_information:string,user_agent:string,cid:string>,session_id:string,swap_number:string,ip_location:struct<country:string,region:string,city:string,ip:string>,major:string,device_information:string,region:string,family:string,location_information:string,session_refresh_time:string,organization:string>"
        }

        ser_de_info {
            parameters            = {
                "serialization.format" = "1"
            }
            serialization_library = "com.amazon.ionhiveserde.IonHiveSerDe"
        }
    }

}

resource "aws_glue_catalog_table" "sessions_org_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-sessions_org_catalog_table"
    owner         = "hadoop"
    parameters    = {
        "classification"                   = "ion"
        "compressionType"                  = "gzip"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "com.amazon.ionhiveserde.formats.IonInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/DynamoDBExport/sessions/sessions-org-full-export-data/"
        number_of_buckets         = -1
        output_format             = "com.amazon.ionhiveserde.formats.IonOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            name       = "item"
            parameters = {}
            type       = "struct<national_string:string,pk:string,session_start_time:string,session_attributes:struct<country:string,ip:string,session_start_time:string,device_type:string,swaps:array<string>,uuid:string,all_formats:boolean,ref:string,landing:string,location_details:struct<country:string,region:string,city:string,ip:string>,google_content_cookies:string,device_information:string,parsed_useragent:struct<os:struct<patch:string,patch_minor:string,family:string,major:string,minor:string>,string:string,device:struct<family:string,brand:string,model:string>,user_agent:struct<patch:string,family:string,major:string,minor:string>>,ids:array<decimal(38,18)>,record_pageview:boolean,location_information:string,perf:struct<dns:decimal(38,18),conn:decimal(38,18),tls:decimal(38,18),wait:decimal(38,18),recv:decimal(38,18)>,user_agent:string,cid:string,session_refresh_time:string>,referrer:string,landing:string,organization:string,session_refresh_time:string>"
        }

        ser_de_info {
            parameters            = {
                "serialization.format" = "1"
            }
            serialization_library = "com.amazon.ionhiveserde.IonHiveSerDe"
        }

    }

}

resource "aws_glue_catalog_table" "phno_audit_new_image_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-phno_audit_new_image"
    owner         = "hadoop"
    parameters    = {
        "EXTERNAL"              = "TRUE"
        "last_modified_by"      = "hadoop"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "org.apache.hadoop.mapred.TextInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/KinesisFirehose/phone-table/fhbase/"
        number_of_buckets         = -1
        output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            comment    = "from deserializer"
            name       = "eventid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventname"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventversion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsource"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "awsregion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "dynamodb"
            parameters = {}
            type       = "struct<approximatecreationdatetime:int,keys:struct<pk:struct<s:string>>,newimage:struct<forward_phone_number_cc:struct<s:string>,e164:struct<s:string>,phno_description:struct<s:string>,session_start_time:struct<s:string>,session_id:struct<s:string>,swap_number_cc:struct<s:string>,session_item:struct<m:struct<country:struct<s:string>,ip:struct<s:string>,session_start_time:struct<s:string>,device_type:struct<s:string>,swaps:struct<l:array<struct<s:string>>>,uuid:struct<s:string>,all_formats:struct<bool:boolean>,ref:struct<s:string>,landing:struct<s:string>,location_details:struct<m:struct<country:struct<s:string>,city:struct<s:string>,ip:struct<s:string>,region:struct<s:string>>>,google_content_cookies:struct<s:string>,device_information:struct<s:string>,parsed_useragent:struct<m:struct<os:struct<m:struct<patch:struct<null:boolean>,patch_minor:struct<null:boolean>,major:struct<s:string>,minor:struct<null:boolean>,family:struct<s:string>>>,string:struct<s:string>,device:struct<m:struct<model:struct<s:string>,family:struct<s:string>,brand:struct<s:string>>>,user_agent:struct<m:struct<patch:struct<s:string>,major:struct<s:string>,minor:struct<s:string>,family:struct<s:string>>>>>,ids:struct<l:array<struct<n:string>>>,record_pageview:struct<bool:boolean>,perf:struct<m:struct<conn:struct<n:string>,wait:struct<n:string>,recv:struct<n:string>,dns:struct<n:string>,tls:struct<n:string>>>,location_information:struct<s:string>,user_agent:struct<s:string>,cid:struct<null:boolean>>>,swap_number:struct<s:string>,forward_phone_number:struct<s:string>,phno_type:struct<s:string>,phno_status:struct<bool:boolean>,usage_counter:struct<n:string>,created_on:struct<s:string>,forward_flow:struct<s:string>,forward_type:struct<s:string>,organization:struct<s:string>,dynamic_pool_name:struct<s:string>,pk:struct<s:string>,phno_campaign:struct<s:string>,session_refresh_time:struct<s:string>>,sequencenumber:string,sizebytes:int,streamviewtype:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsourcearn"
            parameters = {}
            type       = "string"
        }

        ser_de_info {
            parameters            = {
                "paths"                = "awsRegion,dynamodb,eventID,eventName,eventSource,eventSourceARN,eventVersion"
                "serialization.format" = "1"
            }
            serialization_library = "org.openx.data.jsonserde.JsonSerDe"
        }
    }   
}


resource "aws_glue_catalog_table" "sessions_audit_history_new_image_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-sessions_audit_history_new_image"
    owner         = "hadoop"
    parameters    = {
        "EXTERNAL"              = "TRUE"
        "transient_lastDdlTime" = "1702641869"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "org.apache.hadoop.mapred.TextInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/KinesisFirehose/sessions-audit-history/fhbase/"
        number_of_buckets         = -1
        output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            comment    = "from deserializer"
            name       = "eventid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventname"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventversion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsource"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "awsregion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "dynamodb"
            parameters = {}
            type       = "struct<approximatecreationdatetime:int,keys:struct<session_id:struct<s:string>,session_time:struct<s:string>>,newimage:struct<session_event_time:struct<n:string>,national_string:struct<s:string>,session_id:struct<s:string>,new_event:struct<m:struct<referrer:struct<s:string>,landing:struct<s:string>,organization:struct<s:string>,session_start_time:struct<s:string>,national_string:struct<s:string>,pk:struct<s:string>,session_attributes:struct<m:struct<country:struct<s:string>,ip:struct<s:string>,session_start_time:struct<s:string>,device_type:struct<s:string>,swaps:struct<l:array<struct<s:string>>>,uuid:struct<s:string>,all_formats:struct<bool:boolean>,ref:struct<s:string>,landing:struct<s:string>,location_details:struct<m:struct<country:struct<s:string>,city:struct<s:string>,ip:struct<s:string>,region:struct<s:string>>>,google_content_cookies:struct<s:string>,device_information:struct<s:string>,parsed_useragent:struct<m:struct<os:struct<m:struct<patch:struct<null:boolean>,patch_minor:struct<null:boolean>,major:struct<s:string>,minor:struct<null:boolean>,family:struct<s:string>>>,string:struct<s:string>,device:struct<m:struct<model:struct<null:boolean>,family:struct<s:string>,brand:struct<null:boolean>>>,user_agent:struct<m:struct<patch:struct<s:string>,major:struct<s:string>,minor:struct<s:string>,family:struct<s:string>>>>>,ids:struct<l:array<struct<n:string>>>,record_pageview:struct<bool:boolean>,perf:struct<m:struct<conn:struct<n:string>,wait:struct<n:string>,recv:struct<n:string>,dns:struct<n:string>,tls:struct<n:string>>>,location_information:struct<s:string>,user_agent:struct<s:string>,cid:struct<null:boolean>>>,session_refresh_time:struct<s:string>>>,session_time:struct<s:string>,old_event:struct<m:struct<referrer:struct<s:string>,landing:struct<s:string>,organization:struct<s:string>,session_start_time:struct<s:string>,national_string:struct<s:string>,pk:struct<s:string>,session_attributes:struct<m:struct<country:struct<s:string>,ip:struct<s:string>,session_start_time:struct<s:string>,device_type:struct<s:string>,swaps:struct<l:array<struct<s:string>>>,uuid:struct<s:string>,all_formats:struct<bool:boolean>,ref:struct<s:string>,landing:struct<s:string>,location_details:struct<m:struct<country:struct<s:string>,city:struct<s:string>,ip:struct<s:string>,region:struct<s:string>>>,google_content_cookies:struct<s:string>,device_information:struct<s:string>,parsed_useragent:struct<m:struct<os:struct<m:struct<patch:struct<null:boolean>,patch_minor:struct<null:boolean>,major:struct<s:string>,minor:struct<null:boolean>,family:struct<s:string>>>,string:struct<s:string>,device:struct<m:struct<model:struct<null:boolean>,family:struct<s:string>,brand:struct<null:boolean>>>,user_agent:struct<m:struct<patch:struct<s:string>,major:struct<s:string>,minor:struct<s:string>,family:struct<s:string>>>>>,ids:struct<l:array<struct<n:string>>>,record_pageview:struct<bool:boolean>,perf:struct<m:struct<conn:struct<n:string>,wait:struct<n:string>,recv:struct<n:string>,dns:struct<n:string>,tls:struct<n:string>>>,location_information:struct<s:string>,user_agent:struct<s:string>,cid:struct<null:boolean>>>>>>,sequencenumber:string,sizebytes:int,streamviewtype:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsourcearn"
            parameters = {}
            type       = "string"
        }

        ser_de_info {
            parameters            = {
                "paths"                = "awsRegion,dynamodb,eventID,eventName,eventSource,eventSourceARN,eventVersion"
                "serialization.format" = "1"
            }
            serialization_library = "org.openx.data.jsonserde.JsonSerDe"
        }
    }

}

resource "aws_glue_catalog_table" "sessions_audit_new_image_catalog_table" {
    catalog_id    = local.account_id
    database_name = aws_glue_catalog_database.taupehome_leadgen_database.name
    name          = "${local.app}-sessions_audit_new_image"
    owner         = "hadoop"
    parameters    = {
        "EXTERNAL"              = "TRUE"
        "transient_lastDdlTime" = "1702639990"
    }
    retention     = 0
    table_type    = "EXTERNAL_TABLE"

    storage_descriptor {
        bucket_columns            = []
        compressed                = false
        input_format              = "org.apache.hadoop.mapred.TextInputFormat"
        location                  = "s3://${local.data_s3_bucket}/${local.env}/${local.version}/KinesisFirehose/session-table/fhbase/"
        number_of_buckets         = -1
        output_format             = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        parameters                = {}
        stored_as_sub_directories = false

        columns {
            comment    = "from deserializer"
            name       = "eventid"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventname"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventversion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsource"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "awsregion"
            parameters = {}
            type       = "string"
        }
        columns {
            comment    = "from deserializer"
            name       = "dynamodb"
            parameters = {}
            type       = "struct<approximatecreationdatetime:int,keys:struct<national_string:struct<s:string>,pk:struct<s:string>>,newimage:struct<referrer:struct<s:string>,landing:struct<s:string>,organization:struct<s:string>,session_start_time:struct<s:string>,national_string:struct<s:string>,pk:struct<s:string>,session_attributes:struct<m:struct<country:struct<s:string>,ip:struct<s:string>,session_start_time:struct<s:string>,device_type:struct<s:string>,swaps:struct<l:array<struct<s:string>>>,uuid:struct<s:string>,all_formats:struct<bool:boolean>,ref:struct<s:string>,landing:struct<s:string>,location_details:struct<m:struct<country:struct<s:string>,city:struct<s:string>,ip:struct<s:string>,region:struct<s:string>>>,google_content_cookies:struct<s:string>,device_information:struct<s:string>,parsed_useragent:struct<m:struct<os:struct<m:struct<patch:struct<null:boolean>,patch_minor:struct<null:boolean>,major:struct<s:string>,minor:struct<null:boolean>,family:struct<s:string>>>,string:struct<s:string>,device:struct<m:struct<model:struct<null:boolean>,family:struct<s:string>,brand:struct<null:boolean>>>,user_agent:struct<m:struct<patch:struct<s:string>,major:struct<s:string>,minor:struct<s:string>,family:struct<s:string>>>>>,ids:struct<l:array<struct<n:string>>>,record_pageview:struct<bool:boolean>,perf:struct<m:struct<conn:struct<n:string>,wait:struct<n:string>,recv:struct<n:string>,dns:struct<n:string>,tls:struct<n:string>>>,location_information:struct<s:string>,user_agent:struct<s:string>,cid:struct<null:boolean>>>,session_refresh_time:struct<s:string>>,sequencenumber:string,sizebytes:int,streamviewtype:string>"
        }
        columns {
            comment    = "from deserializer"
            name       = "eventsourcearn"
            parameters = {}
            type       = "string"
        }

        ser_de_info {
            parameters            = {
                "paths"                = "awsRegion,dynamodb,eventID,eventName,eventSource,eventSourceARN,eventVersion"
                "serialization.format" = "1"
            }
            serialization_library = "org.openx.data.jsonserde.JsonSerDe"
        }
    }

}
