# == Schema Information
#
# Table name: goals
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  year            :integer
#  month           :integer
#  metric          :string
#  value          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Goal < ActiveRecord::Base
  extend Enumerize

  # Associations
  belongs_to :organization

  # Validations
  validates :organization, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :month, presence: true, numericality: { only_integer: true }
  validates :value, presence: true, numericality: { only_integer: true }

  # Enumerations
  enumerize :metric, in: [:gross_revenue, :customers_count]

  # JSON representation of this model.
  #
  # @param [Hash] _options for JSON generation.
  # @return [Hash] JSON representation of this model.
  def as_json(_options = {})
    {
      id: id,
      year: year,
      month: month,
      metric: metric,
      value: value
    }
  end
end
