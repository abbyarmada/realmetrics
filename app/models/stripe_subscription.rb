# == Schema Information
#
# Table name: stripe_subscriptions
#
#  id                        :integer          not null, primary key
#  organization_id           :integer
#  guid                      :string
#  provider                  :string
#  customer_guid             :string
#  plan_guid                 :string
#  created_at                :datetime
#  started_at                :datetime
#  ended_at                  :datetime
#  trial_started_at          :datetime
#  trial_ended_at            :datetime
#  status                    :string
#  quantity                  :integer
#  tax_percent               :decimal(, )
#  cancel_at_period_end      :boolean
#  canceled_at               :datetime
#  current_period_end_at     :datetime
#  current_period_started_at :datetime
#

class StripeSubscription < ActiveRecord::Base
  # Associations
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
      customer_guid: customer_guid,
      plan_guid: plan_guid,
      created_at: created_at,
      started_at: started_at,
      ended_at: ended_at,
      trial_started_at: trial_started_at,
      trial_ended_at: trial_ended_at,
      status: status,
      quantity: quantity,
      tax_percent: tax_percent,
      cancel_at_period_end: cancel_at_period_end,
      canceled_at: canceled_at,
      current_period_end_at: current_period_end_at,
      current_period_started_at: current_period_started_at
    }
  end

  def plan
    organization.stripe_plans.find_by(guid: plan_guid, provider: :stripe)
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_subscriptions.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeSubscription.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      customer_guid: data['customer'],
      plan_guid: data['plan']['id'],
      created_at: Utility.nullable_time_at(data['created']),
      started_at: Utility.nullable_time_at(data['start']),
      ended_at: Utility.nullable_time_at(data['ended_at']),
      trial_started_at: data['trial_start'],
      trial_ended_at: data['trial_end'],
      status: data['status'],
      quantity: data['quantity'],
      tax_percent: data['tax_percent'],
      cancel_at_period_end: data['cancel_at_period_end'],
      canceled_at: data['canceled_at'],
      current_period_end_at: data['current_period_end'],
      current_period_started_at: data['current_period_start']
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
      :customer_guid,
      :plan_guid,
      :created_at,
      :started_at,
      :ended_at,
      :trial_started_at,
      :trial_ended_at,
      :status,
      :quantity,
      :tax_percent,
      :cancel_at_period_end,
      :canceled_at,
      :current_period_end_at,
      :current_period_started_at
    ]
  end
end
