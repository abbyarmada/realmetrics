# == Schema Information
#
# Table name: stripe_coupons
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  guid               :string
#  provider           :string
#  created_at         :datetime
#  amount_off         :integer
#  currency           :string
#  duration           :string
#  duration_in_months :integer
#  max_redemptions    :integer
#  percent_off        :integer
#  redeem_by          :integer
#  times_redeemed     :integer
#  active             :boolean
#

class StripeCoupon < ActiveRecord::Base
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
      created_at: created_at,
      amount_off: amount_off,
      currency: currency,
      duration: duration,
      duration_in_months: duration_in_months,
      max_redemptions: max_redemptions,
      percent_off: percent_off,
      redeem_by: redeem_by,
      times_redeemed: times_redeemed,
      active: active
    }
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_coupons.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeCoupon.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      created_at: Utility.nullable_time_at(data['created']),
      amount_off: data['amount_off'],
      currency: data['currency'],
      duration: data['duration'],
      duration_in_months: data['duration_in_months'],
      max_redemptions: data['max_redemptions'],
      percent_off: data['percent_off'],
      redeem_by: data['redeem_by'],
      times_redeemed: data['times_redeemed'],
      active: data['valid']
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
      :amount_off,
      :currency,
      :duration,
      :duration_in_months,
      :max_redemptions,
      :percent_off,
      :redeem_by,
      :times_redeemed,
      :active
    ]
  end
end
