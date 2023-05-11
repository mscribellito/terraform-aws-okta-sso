output "okta_trust_policy_json" {
  value       = data.aws_iam_policy_document.okta_trust.json
  description = "Okta trust relationship JSON"
}