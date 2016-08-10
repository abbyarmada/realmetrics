# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  password_digest        :string
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  sign_in_count          :integer          default(0), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password

  # Associations
  has_many :organizations

  # Validations
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }, uniqueness: true
  validates :password, presence: true, length: { maximum: 255 }, on: :create

  # Callbacks
  after_create :init_organization
  after_create :send_new_user_instructions
  before_destroy :can_delete?

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(_options = {})
    {
      id: id,
      email: email,
      confirmed: confirmed_at.present?
    }
  end

  # Can this model be deleted?
  #
  # @return [Boolean] true if it can be deleted, false otherwise.
  def can_delete?
    false
  end

  def confirm!
    update_attributes(confirmed_at: Time.zone.now) unless confirmed_at.present?
  end

  def send_reset_password_instructions
    update_attributes(
      reset_password_sent_at: Time.zone.now,
      reset_password_token: SecureRandom.urlsafe_base64
    )

    UserMailer.new_password(id).deliver_later
  end

  def can_update_password(current_password)
    return false unless authenticate(current_password)
    true
  end

  def change_email!(new_email)
    update_attributes(
      unconfirmed_email: new_email,
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.change_email(id).deliver_later
  end

  #
  # Class methods
  #

  def self.authenticate_with_email_and_password(email, password, sign_in_ip)
    user = User.find_by_email(email)
    return nil unless user && user.authenticate(password)

    user.update_attributes(
      sign_in_count: user.sign_in_count + 1,
      current_sign_in_ip: sign_in_ip,
      current_sign_in_at: Time.zone.now,
      last_sign_in_at: user.current_sign_in_at,
      last_sign_in_ip: user.last_sign_in_ip
    )

    user
  end

  def self.reset_password_with_token(token, password)
    user = User.find_by(reset_password_token: token)
    return false unless user && user.update_attribute(:password, password)
    user
  end

  def self.find_or_create_with_random_password(email)
    user = User.find_by(email: email)
    return user if user.present?
    User.create(
      email: email,
      password: SecureRandom.urlsafe_base64
    )
  end

  private

  def init_organization
    organizations.create!
  end

  def send_new_user_instructions
    update_attributes(
      confirmation_sent_at: Time.zone.now,
      confirmation_token: SecureRandom.urlsafe_base64
    )

    UserMailer.new_user(id).deliver_later
  end
end
