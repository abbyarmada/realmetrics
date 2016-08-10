class Utility
  #
  # Class methods
  #

  # Returns the Time.at for a nullable string.
  #
  # @return [DateTime] datetime
  def self.nullable_time_at(timestamp)
    return nil if timestamp.to_i == 0
    Time.zone.at(timestamp.to_i)
  end
end
