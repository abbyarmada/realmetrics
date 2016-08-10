# == Schema Information
#
# Table name: identities
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  provider        :string
#  uid             :string
#  publishable_key :string
#  token           :string
#  user_id         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Identity < ActiveRecord::Base
  # Associations
  belongs_to :organization

  # Validations
  validates :organization, presence: true
  validates :provider, presence: true, length: { maximum: 255 }
  validates :uid, presence: true, length: { maximum: 255 }
  validates :publishable_key, presence: true, length: { maximum: 255 }
  validates :token, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true, length: { maximum: 255 }

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(_options = {})
    {
      id: id,
      provider: provider,
      account: account
    }
  end

  # Retrieve the Stripe account model directly from the Stripe API.
  #
  # @return [Stripe::Account] The Stripe account model.
  def account
    Stripe::Account.retrieve(uid)
  rescue
    nil
  end

  # Update the identity credentials.
  #
  # @param [String] publishable_key of the identity.
  # @param [String] token of the identity.
  # @param [String] user_id of the identity.
  # @return [Boolean] true if successful, false otherwise.
  def update_credentials(publishable_key, token, user_id)
    update_attributes(
      publishable_key: publishable_key,
      token: token,
      user_id: user_id
    )
  end

  #
  # Class methods
  #

  # Find an identity reference for an organization, provider and uid key.
  # If the search yields no results, a new identity is created.
  #
  # @param [Organization] organization to associate the identity to.
  # @param [String] provider of the identity.
  # @param [String] uid of the identity user.
  # @return [Identity] The found or newly created identity.
  def self.find_or_create_with_omniauth(organization, provider, uid)
    find_or_create_by(organization: organization, provider: provider, uid: uid)
  end
end
