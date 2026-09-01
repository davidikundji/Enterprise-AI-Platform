resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "github-actions-oidc"
  }
}

# ---------------------------------------------------------
# GitHub Actions OIDC trust policy
# Only the configured repository and branch may assume
# the AWS deployment role.
# ---------------------------------------------------------

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    sid    = "GitHubActionsAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-${var.github_repository}-deploy"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Name = "github-actions-${var.github_repository}-deploy"
  }
}

# ---------------------------------------------------------
# GitHub Actions deployment permissions
# ---------------------------------------------------------

data "aws_iam_policy_document" "deployment" {

  # Required because ECR authorization tokens cannot
  # be scoped to a specific repository ARN.
  statement {
    sid    = "ECRAuthentication"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  # Push Docker images only to this project's ECR repository.
  statement {
    sid    = "ECRImageDeployment"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }

  # Allow GitHub Actions to inspect and update
  # only this ECS service.
  statement {
    sid    = "ECSServiceDeployment"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]

    resources = [
      var.ecs_service_arn
    ]
  }

  # Registering a new task definition requires "*"
  # because the new revision does not exist beforehand.
  statement {
    sid    = "ECSTaskDefinition"
    effect = "Allow"

    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition"
    ]

    resources = ["*"]
  }

  # GitHub may pass only the approved ECS execution
  # and application task roles.
  statement {
    sid    = "PassECSTaskRoles"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      var.execution_role_arn,
      var.task_role_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "deployment" {
  name        = "github-actions-${var.github_repository}-deploy"
  description = "Least-privilege permissions for GitHub Actions ECS deployment"

  policy = data.aws_iam_policy_document.deployment.json
}

resource "aws_iam_role_policy_attachment" "deployment" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.deployment.arn
}