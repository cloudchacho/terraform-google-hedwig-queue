output "topic_name" {
  value       = google_pubsub_topic.topic.name
  description = "Consumer topic name"
}

output "subscription_name" {
  value       = google_pubsub_subscription.subscription.name
  description = "Consumer subscription name"
}

output "subscription_path" {
  value       = google_pubsub_subscription.subscription.path
  description = "Consumer subscription path"
}

output "dlq_topic_name" {
  value       = google_pubsub_topic.dlq_topic.name
  description = "DLQ consumer topic name"
}

output "dlq_subscription_name" {
  value       = google_pubsub_subscription.dlq_subscription.name
  description = "DLQ consumer subscription name"
}

output "dlq_subscription_path" {
  value       = google_pubsub_subscription.dlq_subscription.path
  description = "DLQ consumer subscription path"
}
