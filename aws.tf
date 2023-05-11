resource "aws_iam_saml_provider" "okta_console" {
  count = var.create_console ? 1 : 0

  name                   = var.idp_console_name
  saml_metadata_document = okta_app_saml.aws_console[0].metadata
}

resource "aws_iam_saml_provider" "okta_cli" {
  count = var.create_cli ? 1 : 0

  name                   = var.idp_cli_name
  saml_metadata_document = okta_app_saml.aws_cli[0].metadata
}

data "aws_iam_policy_document" "okta_trust" {
  dynamic "statement" {
    for_each = var.create_console ? [1] : []

    content {
      effect = "Allow"
      principals {
        type = "Federated"
        identifiers = [
          aws_iam_saml_provider.okta_console[0].arn
        ]
      }
      actions = [
        "sts:AssumeRoleWithSAML"
      ]
      condition {
        test     = "StringEquals"
        variable = "SAML:aud"
        values = [
          "https://signin.aws.amazon.com/saml"
        ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.create_cli ? [1] : []

    content {
      effect = "Allow"
      principals {
        type = "Federated"
        identifiers = [
          aws_iam_saml_provider.okta_cli[0].arn
        ]
      }
      actions = [
        "sts:AssumeRoleWithSAML"
      ]
      condition {
        test     = "StringEquals"
        variable = "SAML:iss"
        values = [
          "http://www.okta.com/${okta_app_saml.aws_cli[0].entity_key}"
        ]
      }
    }
  }
}

resource "aws_iam_role" "okta_administrator" {
  name               = var.role_administrator_name
  assume_role_policy = data.aws_iam_policy_document.okta_trust.json
}

resource "aws_iam_role_policy_attachment" "okta_administrator" {
  role       = aws_iam_role.okta_administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "okta_read_only" {
  name               = var.role_read_only_name
  assume_role_policy = data.aws_iam_policy_document.okta_trust.json
}

resource "aws_iam_role_policy_attachment" "okta_read_only" {
  role       = aws_iam_role.okta_read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user" "okta_integration_user" {
  count = var.create_okta_integration_user ? 1 : 0

  name = var.user_integration_name
}

resource "aws_iam_access_key" "okta_app_access_key" {
  count = var.create_okta_integration_user && var.create_okta_access_key ? 1 : 0

  user = aws_iam_user.okta_integration_user[0].name
}

resource "aws_iam_user_policy" "okta_integration_user_policy" {
  count = var.create_okta_integration_user ? 1 : 0

  user = aws_iam_user.okta_integration_user[0].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListRoles",
          "iam:ListAccountAliases"
        ],
        Resource = "*"
      }
    ]
  })
}