resource "google_pubsub_topic" "topic" {
  name = "hedwig-${var.queue}"

  labels = var.labels
}

data "google_iam_policy" "topic_policy" {
  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.publisher"
  }

  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_topic_iam_policy" "topic_policy" {
  count = var.iam_service_account == "" ? 0 : 1

  policy_data = data.google_iam_policy.topic_policy.policy_data
  topic       = google_pubsub_topic.topic.name
}

resource "google_pubsub_subscription" "subscription" {
  name  = "hedwig-${var.queue}"
  topic = google_pubsub_topic.topic.name

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = ""
  }

  labels = var.labels
}

data "google_iam_policy" "subscription_policy" {
  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.subscriber"
  }

  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_subscription_iam_policy" "subscription_policy" {
  count = var.iam_service_account == "" ? 0 : 1

  policy_data  = data.google_iam_policy.subscription_policy.policy_data
  subscription = google_pubsub_subscription.subscription.name
}

resource "google_pubsub_topic" "dlq_topic" {
  name = "hedwig-${var.queue}-dlq"

  labels = var.labels
}

data "google_iam_policy" "dlq_topic_policy" {
  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.publisher"
  }

  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_topic_iam_policy" "dlq_topic_policy" {
  count = var.iam_service_account == "" ? 0 : 1

  policy_data = data.google_iam_policy.dlq_topic_policy.policy_data
  topic       = google_pubsub_topic.dlq_topic.name
}

resource "google_pubsub_subscription" "dlq_subscription" {
  name  = "hedwig-${var.queue}-dlq"
  topic = google_pubsub_topic.dlq_topic.name

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = ""
  }

  labels = var.labels
}

data "google_iam_policy" "dlq_subscription_policy" {
  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.subscriber"
  }

  binding {
    members = ["serviceAccount:${var.iam_service_account}"]
    role    = "roles/pubsub.viewer"
  }
}

resource "google_pubsub_subscription_iam_policy" "dlq_subscription_policy" {
  count = var.iam_service_account == "" ? 0 : 1

  policy_data  = data.google_iam_policy.dlq_subscription_policy.policy_data
  subscription = google_pubsub_subscription.dlq_subscription.name
}
