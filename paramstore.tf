resource "aws_ssm_parameter" "phone_num_limit" {
    data_type = "text"
    name      = "${local.app}/leadgen/${local.env}/${local.version}/parameters"
    tags      = {}
    tags_all  = {}
    tier      = "Standard"
    type      = "String"
    value     = local.parameter_value
}