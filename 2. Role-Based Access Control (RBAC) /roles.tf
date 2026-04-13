############################################
# ROLES
############################################

# Custom SYSADMIN Role
resource "snowflake_account_role" "sysadmin_custom" {
  name = "SYSADMIN_CUSTOM"
}

# Data Engineer Role
resource "snowflake_account_role" "data_engineer" {
  name = "DATA_ENGINEER"
}

# Data Analyst Role
resource "snowflake_account_role" "data_analyst" {
  name = "DATA_ANALYST"
}

############################################
# ROLE HIERARCHY
############################################

# DATA_ENGINEER inherits SYSADMIN_CUSTOM
resource "snowflake_grant_account_role" "grant_data_engineer_to_sysadmin" {
  role_name        = snowflake_account_role.data_engineer.name
  parent_role_name = snowflake_account_role.sysadmin_custom.name
}

# DATA_ANALYST inherits SYSADMIN_CUSTOM
resource "snowflake_grant_account_role" "grant_data_analyst_to_sysadmin" {
  role_name        = snowflake_account_role.data_analyst.name
  parent_role_name = snowflake_account_role.sysadmin_custom.name
}

############################################
# WAREHOUSE ACCESS
############################################

# Warehouse usage for Data Engineer
resource "snowflake_grant_privileges_to_account_role" "de_wh_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_engineer.name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "COMPUTE_WH"
  }
}

# Warehouse usage for Data Analyst
resource "snowflake_grant_privileges_to_account_role" "da_wh_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_analyst.name

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "COMPUTE_WH"
  }
}

############################################
# DATABASE ACCESS
############################################

# Database usage for both roles
resource "snowflake_grant_privileges_to_account_role" "db_usage_de" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_engineer.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.test_tf_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "db_usage_da" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_analyst.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.test_tf_db.name
  }
}

############################################
# SCHEMA ACCESS
############################################

# Schema usage for both roles
resource "snowflake_grant_privileges_to_account_role" "schema_usage_de" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_engineer.name

  on_schema {
    schema_name = "${snowflake_database.test_tf_db.name}.${snowflake_schema.raw_schema.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema_usage_da" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.data_analyst.name

  on_schema {
    schema_name = "${snowflake_database.test_tf_db.name}.${snowflake_schema.raw_schema.name}"
  }
}

############################################
# TABLE PERMISSIONS
############################################

# Data Engineer - full access
resource "snowflake_grant_privileges_to_account_role" "employee_full_access_de" {
  privileges        = ["SELECT", "INSERT", "UPDATE", "DELETE"]
  account_role_name = snowflake_account_role.data_engineer.name

  on_schema_object {
    object_type = "TABLE"
    object_name = "${snowflake_database.test_tf_db.name}.${snowflake_schema.raw_schema.name}.${snowflake_table.employee.name}"
  }
}

# Data Analyst - read only
resource "snowflake_grant_privileges_to_account_role" "employee_select_da" {
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.data_analyst.name

  on_schema_object {
    object_type = "TABLE"
    object_name = "${snowflake_database.test_tf_db.name}.${snowflake_schema.raw_schema.name}.${snowflake_table.employee.name}"
  }
}

############################################
# USERS
############################################

# Create sample Data Engineer user
resource "snowflake_user" "de_user" {
  name         = "DE_USER"
  login_name   = "DE_USER"
  password     = "TempPass@12345"
  default_role = snowflake_account_role.data_engineer.name
}

# Create sample Data Analyst user
resource "snowflake_user" "da_user" {
  name         = "DA_USER"
  login_name   = "DA_USER"
  password     = "TempPass@12345"
  default_role = snowflake_account_role.data_analyst.name
}

############################################
# ASSIGN ROLES TO USERS
############################################

resource "snowflake_grant_account_role" "grant_de_role_to_user" {
  role_name = snowflake_account_role.data_engineer.name
  user_name = snowflake_user.de_user.name
}

resource "snowflake_grant_account_role" "grant_da_role_to_user" {
  role_name = snowflake_account_role.data_analyst.name
  user_name = snowflake_user.da_user.name
}
