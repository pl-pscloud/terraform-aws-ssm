resource "aws_iam_role" "pscloud-role-for-onpremises" {
  name = "${var.pscloud_company}-rol-for-ssm-activation-${var.pscloud_env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ssm.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "pscloud-attach-policy-for-ssm" {
  role       = aws_iam_role.pscloud-role-for-onpremises.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ssm_activation" "pscloud-aws-ssm-activation" {
  for_each           = var.pscloud_ssm_activations

  name               = "${var.pscloud_company}-ssm-activation-${each.value.name}-${var.pscloud_env}"
  description        = "Terraform Hybrid Activation"
  iam_role           = aws_iam_role.pscloud-role-for-onpremises.id
  registration_limit = each.value.registration_limit
  depends_on         = [aws_iam_role_policy_attachment.pscloud-attach-policy-for-ssm]
  expiration_date    = each.value.expiration_date
}

