# == Schema Information
#
# Table name: stripe_events
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  guid            :string
#  provider        :string
#  created_at      :datetime
#  event_type      :string
#  event_data      :text
#

class StripeEvent < ActiveRecord::Base
  belongs_to :organization

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(_options = {})
    {
      id: id,
      guid: guid,
      provider: provider,
      created_at: created_at,
      event_type: event_type,
      event_data: event_data
    }
  end

  #
  # Class methods
  #

  # Handle a single Stripe event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  # @param [Hash] data of the event
  def self.handle(organization, event_type, data)
    handle_charge_event(organization, data) if StripeConfiguration.charge_event?(event_type)
    handle_dispute_event(organization, data) if StripeConfiguration.dispute_event?(event_type)
    handle_subscription_event(organization, data) if StripeConfiguration.subscription_event?(event_type)
    handle_customer_event(organization, data) if StripeConfiguration.customer_event?(event_type)
    handle_plan_event(organization, data) if StripeConfiguration.plan_event?(event_type)
  end

  # Handle a single Stripe charge event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  def self.handle_charge_event(organization, data)
    return unless organization.present?
    return unless data['balance_transaction'].present?

    transaction = Stripe::BalanceTransaction.retrieve(data['balance_transaction'], stripe_account: organization.stripe.user_id)
    StripeTransaction.from_stripe(organization, transaction)
  end
  private_class_method :handle_charge_event

  # Handle a single Stripe dispute event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  def self.handle_dispute_event(organization, data)
    return unless organization.present?

    data['balance_transactions'].each do |transaction_data|
      StripeTransaction.from_stripe(organization, transaction_data)
    end
  end
  private_class_method :handle_dispute_event

  # Handle a single Stripe subscription event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  def self.handle_subscription_event(organization, data)
    return unless organization.present?

    StripeSubscription.from_stripe(organization, data)
  end
  private_class_method :handle_subscription_event

  # Handle a single Stripe customer event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  def self.handle_customer_event(organization, data)
    return unless organization.present?

    StripeCustomer.from_stripe(organization, data)
  end
  private_class_method :handle_customer_event

  # Handle a single Stripe plan event.
  #
  # @param [Organization] organization for which to process the event
  # @param [String] event_type to handle
  def self.handle_plan_event(organization, data)
    return unless organization.present?

    StripePlan.from_stripe(organization, data)
  end
  private_class_method :handle_plan_event

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_events.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeEvent.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      created_at: Utility.nullable_time_at(data['created']),
      event_type: data['type'],
      event_data: data['data']['object']
    }
  end

  def self.key_fields
    [
      :organization_id,
      :guid,
      :provider
    ]
  end

  def self.data_fields
    [
      :created_at,
      :event_type,
      :event_data
    ]
  end
end
