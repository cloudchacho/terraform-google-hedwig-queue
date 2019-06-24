variable "queue" {
  description = "Application queue name (e.g. dev-myapp); unique across your infra"
}

variable "labels" {
  description = "Labels to attach to the PubSub topic and subscription"
  type        = "map"
}

variable "alerting" {
  description = "Should Stackdriver alerts be generated?"
  default     = "false"
}

variable "alerting_project" {
  description = "The project where alerting resources should be created (defaults to current project)"
  default     = ""
}

variable "queue_alarm_high_message_count_threshold" {
  description = "Threshold for alerting on high message count in main queue"
  default     = 5000
}

variable "queue_high_message_count_notification_channels" {
  description = "Stackdriver Notification Channels for main queue alarm for high message count (required if alerting is on)"
  type        = "list"
  default     = []
}

variable "dlq_high_message_count_notification_channels" {
  description = "Stackdriver Notification Channels for DLQ alarm for high message count (required if alerting is on)"
  type        = "list"
  default     = []
}
