resource "okta_app_saml" "aws_console" {
  count = var.create_console ? 1 : 0

  accessibility_self_service = false
  app_links_json = jsonencode({
    login = true
  })
  app_settings_json = jsonencode({
    appFilter           = "okta"
    awsEnvironmentType  = "aws.amazon"
    groupFilter         = "aws_(?{{accountid}}\\d+)_(?{{role}}[a-zA-Z0-9+=,.@\\-_]+)"
    identityProviderArn = "${var.arn_prefix}:iam::${var.aws_account_id}:saml-provider/${var.idp_console_name}"
    joinAllRoles        = false
    loginURL            = "https://console.aws.amazon.com/ec2/home"
    roleValuePattern    = "${var.arn_prefix}:iam::$${accountid}:saml-provider/OKTA,${var.arn_prefix}:iam::$${accountid}:role/$${role}"
    sessionDuration     = 3600
    useGroupMapping     = false
  })
  assertion_signed            = false
  auto_submit_toolbar         = true
  hide_ios                    = false
  hide_web                    = false
  honor_force_authn           = false
  implicit_assignment         = false
  label                       = var.console_app_label
  preconfigured_app           = "amazon_aws"
  response_signed             = false
  saml_signed_request_enabled = false
  saml_version                = "2.0"
  status                      = "ACTIVE"
  user_name_template          = "$${source.login}"
  user_name_template_type     = "BUILT_IN"
}

resource "okta_app_saml" "aws_cli" {
  count = var.create_cli ? 1 : 0

  assertion_signed            = true
  audience                    = var.cli_url
  authn_context_class_ref     = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  auto_submit_toolbar         = false
  destination                 = var.cli_url
  digest_algorithm            = "SHA256"
  hide_web                    = true
  honor_force_authn           = true
  implicit_assignment         = false
  label                       = var.cli_app_label
  recipient                   = var.cli_url
  response_signed             = true
  saml_signed_request_enabled = false
  saml_version                = "2.0"
  signature_algorithm         = "RSA_SHA256"
  sso_url                     = var.cli_url
  status                      = "ACTIVE"
  subject_name_id_format      = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  subject_name_id_template    = "$${user.userName}"
  user_name_template          = "$${source.login}"
  user_name_template_type     = "BUILT_IN"
  attribute_statements {
    name      = "https://aws.amazon.com/SAML/Attributes/Role"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values = [
      "${var.arn_prefix}:iam::${var.aws_account_id}:role/${var.role_administrator_name},${var.arn_prefix}:iam::${var.aws_account_id}:saml-provider/${var.idp_cli_name}"
    ]
  }
  attribute_statements {
    name      = "https://aws.amazon.com/SAML/Attributes/RoleSessionName"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values    = ["$${user.email}"]
  }
}