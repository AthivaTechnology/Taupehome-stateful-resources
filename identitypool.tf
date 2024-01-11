resource "aws_cognito_identity_pool" "provisiong_dashboard_identity_pool" {
    allow_classic_flow               = true
    allow_unauthenticated_identities = false
    identity_pool_name               = "${local.app}-auth_seperation_identitypool"
    openid_connect_provider_arns     = []
    saml_provider_arns               = []
    supported_login_providers        = {}
    tags                             = {}
    tags_all                         = {}

    cognito_identity_providers {
        client_id               = local.user_pool_client_id_value
        provider_name           = local.provider_name_value
        server_side_token_check = false
    }

}

resource "aws_cognito_identity_pool_roles_attachment" "provisiong_dashboard_identity_pool_auth_access" {
  identity_pool_id = aws_cognito_identity_pool.provisiong_dashboard_identity_pool.id
  roles = {
    "authenticated" = aws_iam_role.auth_seperation_identitypool_role.arn
  }
}

