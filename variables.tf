variable "queue" {
  description = "Application queue name (e.g. dev-myapp); unique across your infra"
}

variable "labels" {
  description = "Labels to attach to the PubSub topic and subscription"
  type        = map(string)
}

variable "iam_service_account" {
  description = "The IAM service account to create exclusive IAM permissions for the topic"
  default     = ""
}

variable "retry_policy" {
  description = "A policy that specifies how Pub/Sub retries message delivery for this subscription. If not set, the default retry policy is applied. This generally implies that messages will be retried as soon as possible for healthy subscribers. RetryPolicy will be triggered on NACKs or acknowledgement deadline exceeded events for a given message"
  type = object({
    minimum_backoff = string
    maximum_backoff = string
  })
  default = null
}
