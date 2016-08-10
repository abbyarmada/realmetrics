# == Schema Information
#
# Table name: stripe_transactions
#
#  id               :integer          not null, primary key
#  organization_id  :integer
#  guid             :string
#  provider         :string
#  created_at       :datetime
#  currency         :string
#  gross_amount     :integer
#  fee_amount       :integer
#  net_amount       :integer
#  transaction_type :string
#

class StripeTransaction < ActiveRecord::Base
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
      currency: currency,
      gross_amount: gross_amount,
      fee_amount: fee_amount,
      net_amount: net_amount,
      transaction_type: transaction_type
    }
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_transactions.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeTransaction.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      created_at: Utility.nullable_time_at(data['created']),
      currency: data['currency'],
      gross_amount: data['amount'],
      fee_amount: data['fee'],
      net_amount: data['net'],
      transaction_type: data['type']
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
      :currency,
      :gross_amount,
      :fee_amount,
      :net_amount,
      :transaction_type,
    ]
  end
end
