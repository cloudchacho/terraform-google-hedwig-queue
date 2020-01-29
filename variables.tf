variable "queue" {
  description = "Application queue name (e.g. dev-myapp); unique across your infra"
}

variable "labels" {
  description = "Labels to attach to the PubSub topic and subscription"
  type        = "map"
}

variable "iam_service_account" {
  description = "The IAM service account to create exclusive IAM permissions for the topic"
  default     = ""
}
