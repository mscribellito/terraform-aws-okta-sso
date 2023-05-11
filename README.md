# terraform-aws-okta-sso

This is a Terraform module which configures SSO for the AWS Console and CLI with Okta. Console access utilizes the AWS app from Okta's app catalog and CLI uses Rapid7's [Awsaml](https://github.com/rapid7/awsaml). Two Okta apps will be created - one for the console and another for CLI.

Okta will be configured as an identity provider in your AWS account in addition to being a trusted source in AWS role. An IAM user will also be created along with an access key for Okta and AWS integration.

## Prerequisites

* AWS account
* Okta organization
* [Awsaml](https://github.com/rapid7/awsaml) installed

## Usage

```hcl
data "aws_caller_identity" "current" {}

module "okta-sso" {
  source = "./terraform-aws-okta-sso"

  aws_account_id = data.aws_caller_identity.current.account_id
}

provider "okta" {
  org_name = "<org-name>"
  base_url = "okta.com"
}
```

## Configuration

After deployment, people/groups will need to be assigned to the Okta applications.

### Console

* In the Okta Admin Console, select the **Provisioning** tab for the AWS Console app, then click **Edit**.
* Click **Enable API Integration**.
* Enter the **Access Key** and **Secret Key** values.
* Click **Test API Credentials** to verify API credentials are working.
* To be able to update Roles and Permissions from AWS you need to enable Create Users and Update User Attributes.
* Click **Save**.

*Note:* AWS Access Key and Secret Key can be pulled from the state file using the following command:

`terraform state pull | jq '.resources[] | select(.type == "aws_iam_access_key") | .instances[0].attributes'`

### CLI

* In the Okta Admin Console, select the **Sign On** tab for the AWS CLI app.
* Copy the **Metadata URL**.
* Run **Awsaml** and give it your app's metadata.

## References

* https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service.html
* https://github.com/rapid7/awsaml

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.66.1 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.1 |
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.okta_app_access_key](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_access_key) | resource |
| [aws_iam_role.okta_administrator](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_role) | resource |
| [aws_iam_role.okta_read_only](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.okta_administrator](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.okta_read_only](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_saml_provider.okta_cli](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_saml_provider) | resource |
| [aws_iam_saml_provider.okta_console](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_saml_provider) | resource |
| [aws_iam_user.okta_integration_user](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.okta_integration_user_policy](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/resources/iam_user_policy) | resource |
| [okta_app_saml.aws_cli](https://registry.terraform.io/providers/okta/okta/4.0.0/docs/resources/app_saml) | resource |
| [okta_app_saml.aws_console](https://registry.terraform.io/providers/okta/okta/4.0.0/docs/resources/app_saml) | resource |
| [aws_iam_policy_document.okta_trust](https://registry.terraform.io/providers/hashicorp/aws/4.66.1/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arn_prefix"></a> [arn\_prefix](#input\_arn\_prefix) | n/a | `string` | `"arn:aws"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_cli_app_label"></a> [cli\_app\_label](#input\_cli\_app\_label) | Label of CLI app | `string` | `"AWS CLI"` | no |
| <a name="input_cli_url"></a> [cli\_url](#input\_cli\_url) | Awsaml SSO URL | `string` | `"http://localhost:2600/sso/saml"` | no |
| <a name="input_console_app_label"></a> [console\_app\_label](#input\_console\_app\_label) | Label of Console app | `string` | `"AWS Console"` | no |
| <a name="input_create_cli"></a> [create\_cli](#input\_create\_cli) | Controls if CLI SSO should be configured | `bool` | `true` | no |
| <a name="input_create_console"></a> [create\_console](#input\_create\_console) | Controls if Console SSO should be configured | `bool` | `true` | no |
| <a name="input_create_okta_access_key"></a> [create\_okta\_access\_key](#input\_create\_okta\_access\_key) | Controls if Okta access key should be configured | `bool` | `true` | no |
| <a name="input_create_okta_integration_user"></a> [create\_okta\_integration\_user](#input\_create\_okta\_integration\_user) | Controls if Okta integration user should be configured | `bool` | `true` | no |
| <a name="input_idp_cli_name"></a> [idp\_cli\_name](#input\_idp\_cli\_name) | Identity provider name for CLI | `string` | `"OktaCLI"` | no |
| <a name="input_idp_console_name"></a> [idp\_console\_name](#input\_idp\_console\_name) | Identity provider name for console | `string` | `"OktaConsole"` | no |
| <a name="input_role_administrator_name"></a> [role\_administrator\_name](#input\_role\_administrator\_name) | Administrator role name | `string` | `"OktaAdministrator"` | no |
| <a name="input_role_read_only_name"></a> [role\_read\_only\_name](#input\_role\_read\_only\_name) | Read Only role name | `string` | `"OktaReadOnly"` | no |
| <a name="input_user_integration_name"></a> [user\_integration\_name](#input\_user\_integration\_name) | IAM user name for Okta integration | `string` | `"OktaIntegration"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_okta_trust_policy_json"></a> [okta\_trust\_policy\_json](#output\_okta\_trust\_policy\_json) | Okta trust relationship JSON |
