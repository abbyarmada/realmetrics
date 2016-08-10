# == Schema Information
#
# Table name: organizations
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  initial_crawl_completed :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Organization < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :identities
  has_many :goals
  has_many :stripe_coupons
  has_many :stripe_customers
  has_many :stripe_discounts
  has_many :stripe_events
  has_many :stripe_plans
  has_many :stripe_subscriptions
  has_many :stripe_transactions

  # Validations
  validates :user, presence: true

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(_options = {})
    {
      id: id,
      integrations: {
        stripe: stripe
      },
      initial_crawl_completed: initial_crawl_completed
    }
  end

  # Find the Stripe identity for the organization.
  #
  # @return [Identity] The Stripe identity of this organization.
  def stripe
    identities.find_by(provider: 'stripe_connect')
  end

  # Add a job in the queue to asynchronously crawl organization's data from Stripe.
  #
  # @return [Boolean] true if the job was properly created, false otherwise.
  def crawl_stripe_data
    StripeCrawler.delay.crawl(self)
  end

  # Set goals automatically from existing values. It fetch the first goal then
  # automatically creates missing goals with a 10% compound growth.
  #
  # @return [Boolean] true if successful, false otherwise.
  def set_goals(year, month, metric, value, growth)
    (year..Time.zone.today.year).each do |year|
      (month..12).each do |month|
        goals.find_or_initialize_by(
          year: year,
          month: month,
          metric: metric
        ).update_attributes(
          value: value.to_i
        )

        value *= 1 + (growth / 100.0)
      end
    end

    true
  end
end
