class StripeConfiguration
  #
  # Class methods
  #

  # Returns the list of events that are watched by the app.
  #
  # @return [Array] List of watched events.
  def self.watched_events
    [
      # Charges events
      'charge.captured',
      'charge.failed',
      'charge.refunded',
      'charge.succeeded',
      'charge.updated',

      # Disputes events
      'charge.dispute.closed',
      'charge.dispute.created',
      'charge.dispute.funds_reinstated',
      'charge.dispute.funds_withdrawn',
      'charge.dispute.updated',

      # Subscriptions events
      'customer.subscription.created',
      'customer.subscription.deleted',
      'customer.subscription.trial_will_end',
      'customer.subscription.updated',

      # Customers events
      'customer.created',
      'customer.updated',
      'customer.deleted',

      # Plans events
      'plan.created',
      'plan.updated',
      'plan.deleted'
    ]
  end

  # Check if the event is a charge event.
  #
  # @return [String] event_type to be checked.
  def self.charge_event?(event_type)
    [
      'charge.captured',
      'charge.failed',
      'charge.refunded',
      'charge.succeeded',
      'charge.updated'
    ].include?(event_type)
  end

  # Check if the event is a dispute event.
  #
  # @return [String] event_type to be checked.
  def self.dispute_event?(event_type)
    [
      'charge.dispute.closed',
      'charge.dispute.created',
      'charge.dispute.funds_reinstated',
      'charge.dispute.funds_withdrawn',
      'charge.dispute.updated'
    ].include?(event_type)
  end

  # Check if the event is a subscription event.
  #
  # @return [String] event_type to be checked.
  def self.subscription_event?(event_type)
    [
      'customer.subscription.created',
      'customer.subscription.deleted',
      'customer.subscription.trial_will_end',
      'customer.subscription.updated'
    ].include?(event_type)
  end

  # Check if the event is a customer event.
  #
  # @return [String] event_type to be checked.
  def self.customer_event?(event_type)
    [
      'customer.created',
      'customer.updated',
      'customer.deleted'
    ].include?(event_type)
  end

  # Check if the event is a plan event.
  #
  # @return [String] event_type to be checked.
  def self.plan_event?(event_type)
    [
      'plan.created',
      'plan.updated',
      'plan.deleted'
    ].include?(event_type)
  end
end
