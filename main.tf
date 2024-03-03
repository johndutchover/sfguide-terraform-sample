terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.87.0"
    }
  }
}

provider "snowflake" {
  role = "SYSADMIN"
  private_key = file("~/.ssh/snowflake_key")
}

resource "snowflake_schema" "schema" {
  name      = "TF_DEMO"
  database  = "TF_DEMO"
  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
}
