terraform {
  required_version = ">= 1.0.0"

  required_providers {
    snowflake = {
      source  = "snowflake-Labs/snowflake"
      version = "0.87.0"
    }
  }
}

provider "snowflake" {
  user                   = var.snowflake_tf_user
  account                = var.snowflake_account
  private_key            = file(var.snowflake_tf_user_pke_path)
  private_key_passphrase = var.snowflake_tf_user_pke_pass
  role                   = var.snowflake_tf_user_role
  authenticator          = var.snowflake_tf_user_authenticator
}

resource "snowflake_schema" "schema" {
  name                = "TF_DEMO"
  database            = "TF_DEMO"
  is_transient        = false
  is_managed          = false
  data_retention_days = 1
  depends_on          = [snowflake_warehouse.warehouse, snowflake_database.db]
}

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "xsmall"
}
