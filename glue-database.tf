resource "aws_glue_catalog_database" "taupehome_leadgen_database" {
    catalog_id  = local.account_id
    name        = "${local.app}-leadgen-database"
    parameters  = {}
    tags        = {}
    tags_all    = {}

    create_table_default_permission {
        permissions = [
            "ALL",
        ]

        principal {
            data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
        }
    }

}