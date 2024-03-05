# Terraforming Snowflake

## [QuickStart](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html)

### Snowflake environment
|  Cloud Platform | Cloud Region         | Region ID |
|----------------:|----------------------|-----------|
| Microsoft Azure | East US 2 (Virginia) | eastus2   |

### [Terraform Snowflake Provider](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)

### Setup

#### Bootstrap Snowflake Account


#### [Keypair Authentication Environment Variables](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs#keypair-authentication-environment-variables)
```bash
openssl genrsa -out snowflake_tf_key 4096
openssl rsa -in snowflake_tf_key -pubout -out snowflake_tf_key.pub
openssl pkcs8 -topk8 -inform pem -in snowflake_tf_key -outform PEM -v2 aes-256-cbc -out snowflake_tf_key.p8
```
**Important**
> When setting the RSA_PUBLIC_KEY in Snowflake, you need to remove the PEM header and delimeters, 
as well as **all spaces** and **line breaks**!
> > (-----BEGIN PUBLIC KEY----- and -----END PUBLIC KEY-----).

#### [Setup Terraform Authentication](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html#3)
I used a `terraform.tfvars` file to populate variables defined in the `variables.tf` file.

Note: The SNOWFLAKE_ACCOUNT variable needs to be in "URL" format. More info [here](https://docs.snowflake.com/en/user-guide/admin-account-identifier#using-an-account-name-as-an-identifier).

#### Provider deprecation note (v0.74.0 and higher)
[Deprecation error message after provider upgrade from 0.66.2 to 0.85.0 #2476](https://github.com/Snowflake-Labs/terraform-provider-snowflake/issues/2476#issuecomment-1934001187).

Since the `private_key_path` attribute has been deprecated in favor of `private_key`, use the `file()` function to read the private key from a file when [declaring resources](https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html#4).

```terraform
provider "snowflake" {
# before
private_key_path = "<filepath>"

# after
private_key = file("<filepath>")
}
```
