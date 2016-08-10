class ReportBase
  extend ActiveModel::Callbacks
  define_model_callbacks :initialize

  def initialize(attributes = {})
    run_callbacks :initialize do
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  end

  attr_accessor :organization_id, :from_date, :to_date

  def sql_table(sql_query, *params)
    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [sql_query, *params])
    )
  end
end
