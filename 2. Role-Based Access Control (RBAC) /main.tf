# Create Database
resource "snowflake_database" "test_tf_db" {
  name = "TERRAFORM_TEST_DB"
}

# Create Schema (RAW)
resource "snowflake_schema" "raw_schema" {
  database = snowflake_database.test_tf_db.name
  name     = "RAW"
}

# Create Table (EMPLOYEE)
resource "snowflake_table" "employee" {
  database = snowflake_database.test_tf_db.name
  schema   = snowflake_schema.raw_schema.name
  name     = "EMPLOYEE"

  column {
    name = "EMP_ID"
    type = "NUMBER"
  }

  column {
    name = "FIRST_NAME"
    type = "VARCHAR(100)"
  }

  column {
    name = "LAST_NAME"
    type = "VARCHAR(100)"
  }

  column {
    name = "EMAIL"
    type = "VARCHAR(150)"
  }

  column {
    name = "CREATED_AT"
    type = "TIMESTAMP_NTZ"
  }
}
