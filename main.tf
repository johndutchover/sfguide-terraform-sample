terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.87.0"
    }
  }
}

provider "snowflake" {
  role        = "SYSADMIN"
  private_key = file("~/.ssh/snowflake_key")
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

resource "snowflake_role" "role" {
  provider = snowflake.security_admin
  name     = "TF_DEMO_SVC_ROLE"
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  account_role_name = snowflake_role.role.name
  on_account        = true
  privileges        = ["USAGE"]
}

resource "snowflake_schema" "schema" {
  name                = "TF_DEMO"
  database            = "TF_DEMO"
  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant" {
  account_role_name = snowflake_role.role.name
  on_account        = true
  privileges        = ["USAGE"]
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_grant" {
  account_role_name = snowflake_role.role.name
  on_account        = true
  privileges        = ["USAGE"]
}

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "snowflake_user" "user" {
  provider          = snowflake.security_admin
  name              = "tf_demo_user"
  default_warehouse = snowflake_warehouse.warehouse.name
  default_role      = snowflake_role.role.name
  default_namespace = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}
resource "snowflake_grant_privileges_to_account_role" "user_grant" {
  account_role_name = snowflake_role.role.name
  on_account        = true
  privileges        = ["ACCOUNTADMIN"]
}

resource "snowflake_role_grants" "grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.role.name
  users     = [snowflake_user.user.name]
}

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name = "TF_DEMO"
}
