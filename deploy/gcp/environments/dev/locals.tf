locals {
  # See https://cloud.google.com/build/docs/automate-builds-pubsub-events#ar_build_trigger
  request_id_substitution = "$(body.message.data.requestId)"
}
