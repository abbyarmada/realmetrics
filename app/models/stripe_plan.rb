# == Schema Information
#
# Table name: stripe_plans
#
#  id                   :integer          not null, primary key
#  organization_id      :integer
#  guid                 :string
#  provider             :string
#  name                 :string
#  statement_descriptor :string
#  trial_period_days    :integer
#  created_at           :datetime
#  amount               :integer
#  currency             :string
#  interval             :string
#  interval_count       :integer
#

class StripePlan < ActiveRecord::Base
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
      name: name,
      statement_descriptor: statement_descriptor,
      trial_period_days: trial_period_days,
      created_at: created_at,
      amount: amount,
      currency: currency,
      interval: interval,
      interval_count: interval_count,
      subscribers_count: StripeSubscription.where('NOW() >= started_at AND (ended_at IS NULL OR NOW() <= ended_at) AND plan_guid = ?', guid).size
    }
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_plans.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripePlan.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      name: data['name'],
      statement_descriptor: data['statement_descriptor'],
      trial_period_days: data['trial_period_days'],
      created_at: Utility.nullable_time_at(data['created']),
      amount: data['amount'],
      currency: data['currency'],
      interval: data['interval'],
      interval_count: data['interval_count']
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
      :name,
      :statement_descriptor,
      :trial_period_days,
      :created_at,
      :amount,
      :currency,
      :interval,
      :interval_count,
    ]
  end
end
