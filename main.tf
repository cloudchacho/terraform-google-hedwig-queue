resource "google_pubsub_topic" "topic" {
  name = "hedwig-${var.queue}"

  labels = "${var.labels}"
}

resource "google_pubsub_subscription" "subscription" {
  name  = "hedwig-${var.queue}"
  topic = "${google_pubsub_topic.topic.name}"

  ack_deadline_seconds = 20

  labels = "${var.labels}"
}

resource "google_pubsub_topic" "dlq_topic" {
  name = "hedwig-${var.queue}-dlq"

  labels = "${var.labels}"
}

resource "google_pubsub_subscription" "dlq_subscription" {
  name  = "hedwig-${var.queue}-dlq"
  topic = "${google_pubsub_topic.dlq_topic.name}"

  ack_deadline_seconds = 20

  labels = "${var.labels}"
}

resource "google_monitoring_alert_policy" "high_message_alert" {
  count = "${var.alerting == "true" ? 1 : 0}"

  project = "${var.alerting_project}"

  display_name = "${title(var.queue)} Hedwig queue message count too high"
  combiner     = "OR"

  conditions {
    display_name = "${title(var.queue)} Hedwig queue message count too high"

    condition_threshold {
      threshold_value = "${var.queue_alarm_high_message_count_threshold}" // Number of messages
      comparison      = "COMPARISON_GT"
      duration        = "300s"                                            // Seconds

      filter = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"subscription_id\"=\"${google_pubsub_subscription.subscription.name}\""

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = "${var.queue_high_message_count_notification_channels}"
}

resource "google_monitoring_alert_policy" "dlq_alert" {
  count = "${var.alerting == "true" ? 1 : 0}"

  project = "${var.alerting_project}"

  display_name = "${title(var.queue)} Hedwig DLQ is non-empty"
  combiner     = "OR"

  conditions {
    display_name = "${title(var.queue)} Hedwig DLQ is non-empty"

    condition_threshold {
      threshold_value = "1"             // Number of messages
      comparison      = "COMPARISON_GT"
      duration        = "60s"           // Seconds

      filter = "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\" resource.label.\"subscription_id\"=\"${google_pubsub_subscription.dlq_subscription.name}\""

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = "${var.dlq_high_message_count_notification_channels}"
}
