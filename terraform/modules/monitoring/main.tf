resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-high-cpu"
  alarm_description   = "ECS service CPU utilization is above the configured threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  period      = 60
  statistic   = "Average"
  threshold   = var.cpu_alarm_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-high-cpu"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_memory" {
  alarm_name          = "${var.project_name}-${var.environment}-ecs-high-memory"
  alarm_description   = "ECS service memory utilization is above the configured threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "MemoryUtilization"
  namespace   = "AWS/ECS"
  period      = 60
  statistic   = "Average"
  threshold   = var.memory_alarm_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-high-memory"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-unhealthy-targets"
  alarm_description   = "One or more ALB targets are unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "UnHealthyHostCount"
  namespace   = "AWS/ApplicationELB"
  period      = 60
  statistic   = "Maximum"
  threshold   = 1

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-unhealthy-targets"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-target-5xx"
  alarm_description   = "Application targets are returning HTTP 5XX errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  metric_name = "HTTPCode_Target_5XX_Count"
  namespace   = "AWS/ApplicationELB"
  period      = 60
  statistic   = "Sum"
  threshold   = 5

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-target-5xx"
  }
}