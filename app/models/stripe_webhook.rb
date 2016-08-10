class StripeWebhook
  #
  # Class methods
  #

  # Execute the webhook.
  #
  # @param [Hash] event_json sent by Stripe.
  def self.execute(event_json)
    return unless event_json['livemode']
    return unless StripeConfiguration.watched_events.include?(event_json['type'])

    identity = Identity.find_by(user_id: event_json['user_id'])

    if identity.present?
      StripeEvent.from_stripe(identity.organization, event_json)
      StripeEvent.handle(identity.organization, event_json['type'], event_json['data']['object'])
    end
  end
end
