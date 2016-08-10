# == Schema Information
#
# Table name: stripe_customers
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  guid            :string
#  provider        :string
#  email           :string
#  account_balance :integer
#  created_at      :datetime
#  currency        :string
#  delinquent      :boolean
#

class StripeCustomer < ActiveRecord::Base
  # Associations
  belongs_to :organization

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(options = {})
    data = {
      id: id,
      guid: guid,
      provider: provider,
      email: email,
      account_balance: account_balance,
      created_at: created_at,
      currency: currency,
      delinquent: delinquent,
      current_plan: current_plan
    }

    data[:stripe] = stripe unless options[:format] == :list

    data
  end

  def stripe
    Stripe::Customer.retrieve(guid, stripe_account: organization.stripe.user_id)
  end

  def current_plan
    s = organization.stripe_subscriptions.where('NOW() >= started_at AND (ended_at IS NULL OR NOW() <= ended_at) AND customer_guid = ?', guid)
    s.first.plan.guid unless s.size.empty?
  end

  # Find or create a new model using data from Stripe.
  #
  # @param [Organization] organization associated with the Stripe data.
  # @param [Hash] data being passed by Stripe.
  # @return [Boolean] True if the model was successfully updated, false otherwise.
  def self.from_stripe(organization, data)
    organization.stripe_customers.find_or_initialize_by(
      guid: data['id'],
      provider: :stripe
    ).update_attributes(attributes_from_stripe(organization, data))
  end

  def self.build_from_stripe(organization, data)
    StripeCustomer.new(attributes_from_stripe(organization, data))
  end

  def self.attributes_from_stripe(organization, data)
    {
      organization: organization,
      guid: data['id'],
      provider: :stripe,
      email: data['email'],
      account_balance: data['account_balance'],
      created_at: Utility.nullable_time_at(data['created']),
      currency: data['currency'],
      delinquent: data['delinquent']
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
      :email,
      :account_balance,
      :created_at,
      :currency,
      :delinquent
    ]
  end
end
