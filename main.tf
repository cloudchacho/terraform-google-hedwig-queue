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
