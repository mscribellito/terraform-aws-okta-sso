variable "aws_account_id" {
  type = string
}

variable "arn_prefix" {
  type    = string
  default = "arn:aws"
}

variable "create_console" {
  type        = bool
  default     = true
  description = "Controls if Console SSO should be configured"
}

variable "create_cli" {
  type        = bool
  default     = true
  description = "Controls if CLI SSO should be configured"
}

variable "create_okta_integration_user" {
  type        = bool
  default     = true
  description = "Controls if Okta integration user should be configured"
}

variable "create_okta_access_key" {
  type        = bool
  default     = true
  description = "Controls if Okta access key should be configured"
}

variable "idp_console_name" {
  type        = string
  default     = "OktaConsole"
  description = "Identity provider name for console"
}

variable "idp_cli_name" {
  type        = string
  default     = "OktaCLI"
  description = "Identity provider name for CLI"
}

variable "role_administrator_name" {
  type        = string
  default     = "OktaAdministrator"
  description = "Administrator role name"
}

variable "role_read_only_name" {
  type        = string
  default     = "OktaReadOnly"
  description = "Read Only role name"
}

variable "user_integration_name" {
  type        = string
  default     = "OktaIntegration"
  description = "IAM user name for Okta integration"
}

variable "console_app_label" {
  type        = string
  default     = "AWS Console"
  description = "Label of Console app"
}

variable "cli_app_label" {
  type        = string
  default     = "AWS CLI"
  description = "Label of CLI app"
}

variable "cli_url" {
  type        = string
  default     = "http://localhost:2600/sso/saml"
  description = "Awsaml SSO URL"
}