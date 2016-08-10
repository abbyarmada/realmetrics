# == Schema Information
#
# Table name: stripe_discounts
#
#  id                :integer          not null, primary key
#  organization_id   :integer
#  coupon_guid       :string
#  customer_guid     :string
#  subscription_guid :string
#  started_at        :datetime
#  ended_at          :datetime
#

class StripeDiscount < ActiveRecord::Base
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
      coupon_guid: coupon_guid,
      customer_guid: customer_guid,
      subscription_guid: subscription_guid,
      started_at: started_at,
      ended_at: ended_at
    }
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_discounts.find_or_initialize_by(
      customer_guid: data['customer'],
      subscription_guid: data['subscription'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeDiscount.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      customer_guid: data['customer'],
      subscription_guid: data['subscription'],
      provider: :stripe,
      coupon_guid: data['coupon']['id'],
      started_at: Utility.nullable_time_at(data['start']),
      ended_at: Utility.nullable_time_at(data['end'])
    }
  end

  def self.key_fields
    [
      :organization_id,
      :customer_guid,
      :subscription_guid,
      :provider
    ]
  end

  def self.data_fields
    [
      :started_at,
      :ended_at
    ]
  end
end
