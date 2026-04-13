terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "2.14.0"
    }
  }
}

provider "snowflake" {
  organization_name = "BHGIECX"
  account_name      = "GTB05030"
  user              = "MYTRIALACCOUNT"
  password          = "Kipi@123456789"
  role              = "ACCOUNTADMIN"

  preview_features_enabled = ["snowflake_table_resource"]
}
