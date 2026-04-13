############################################
# WAREHOUSE
############################################

resource "snowflake_warehouse" "env_wh" {
  name           = var.warehouse_name
  warehouse_size = var.warehouse_size
  auto_suspend   = var.warehouse_auto_suspend
  auto_resume    = true
  initially_suspended = true
}

############################################
# DATABASE
############################################

resource "snowflake_database" "env_db" {
  name = var.db_name
}

############################################
# SCHEMA
############################################

resource "snowflake_schema" "raw_schema" {
  database = snowflake_database.env_db.name
  name     = "RAW"
}

############################################
# ROLE
############################################

resource "snowflake_account_role" "env_role" {
  name = var.access_role
}

############################################
# GRANT WAREHOUSE ACCESS
############################################

resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.env_role.name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.env_wh.name
  }
}

############################################
# GRANT DATABASE ACCESS
############################################

resource "snowflake_grant_privileges_to_account_role" "db_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.env_role.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.env_db.name
  }
}

############################################
# GRANT SCHEMA ACCESS
############################################

resource "snowflake_grant_privileges_to_account_role" "schema_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.env_role.name

  on_schema {
    schema_name = "${snowflake_database.env_db.name}.${snowflake_schema.raw_schema.name}"
  }
}
