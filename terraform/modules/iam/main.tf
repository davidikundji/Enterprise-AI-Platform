data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "execution" {
  name = "${var.project_name}-${var.environment}-ecs-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-task-role"
  }
}

data "aws_iam_policy_document" "bedrock" {
  statement {
    sid    = "InvokeBedrockInferenceProfile"
    effect = "Allow"

    actions = [
      "bedrock:InvokeModel"
    ]

    resources = concat(
      [
        "arn:aws:bedrock:${var.aws_region}:${data.aws_caller_identity.current.account_id}:inference-profile/${var.bedrock_inference_profile_id}"
      ],
      [
        for region in var.bedrock_destination_regions :
        "arn:aws:bedrock:${region}::foundation-model/${var.bedrock_model_id}"
      ]
    )
  }
}

resource "aws_iam_policy" "bedrock" {
  name        = "${var.project_name}-${var.environment}-bedrock-policy"
  description = "Allows the ECS application task to invoke the approved Bedrock model"

  policy = data.aws_iam_policy_document.bedrock.json
}

resource "aws_iam_role_policy_attachment" "task_bedrock" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.bedrock.arn
}