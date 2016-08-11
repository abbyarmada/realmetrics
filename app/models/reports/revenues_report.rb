class RevenuesReport < ReportBase
  attr_accessor :data, :kpis
  after_initialize :render

  private

  def render
    @data = []
    @kpis = {}
    last_year = nil

    results.each do |res|
      year = res['year'].to_i
      month = res['month'].to_i

      if last_year != year
        last_year = year

        @data << {
          year: year,
          data: Array.new(12)
        }
      end

      @data[-1][:data][month - 1] = {
        month: res['month'].to_i,
        amount: res['amount'].to_i,
        goal: res['goal'].to_i,
        completion: res['completion'].to_i,
        growth: res['growth'].to_i
      }
    end

    @kpis[:ytd] = aggregate_to_day_values(:ytd)
    @kpis[:mtd] = aggregate_to_day_values(:mtd)
  end

  def aggregate_to_day_values(aggregation_type)
    amount = 0
    goal = 0
    completion = 0
    growth = 0

    @data.map do |x|
      x[:data].map do |y|
        next unless (aggregation_type == :mtd && y[:month] < Time.zone.today.month) || aggregation_type == :ytd

        amount += y[:amount]
        goal += y[:goal]
        completion += y[:completion]
        growth += y[:growth]
      end if x[:year] == Time.zone.today.year
    end

    { amount: amount, goal: goal, completion: completion, growth: growth }
  end

  def results
    sql = %q{
      SELECT A.year
           , B.month
           , SUM(stripe_transactions.gross_amount) AS amount
           , goals.value AS goal
           , SUM(stripe_transactions.gross_amount) * 100.0 / goals.value AS completion
           , 0 AS growth
        FROM (SELECT generate_series(
                       CAST(EXTRACT(YEAR FROM :from_date::DATE) AS INTEGER),
                       CAST(EXTRACT(YEAR FROM :to_date::DATE) AS INTEGER)
              ) AS year) A
        JOIN (SELECT generate_series(1, 12) AS month) B ON A.year != B.month
        LEFT JOIN stripe_transactions ON stripe_transactions.organization_id = :organization_id
                              AND EXTRACT(YEAR FROM stripe_transactions.created_at) = A.year
                              AND EXTRACT(MONTH FROM stripe_transactions.created_at) = B.month
                              AND stripe_transactions.transaction_type IN ('charge', 'refund')
        LEFT JOIN goals ON goals.organization_id = :organization_id
                       AND goals.year = A.year
                       AND goals.month = B.month
                       AND goals.metric = 'gross_revenue'
        GROUP BY A.year
               , B.month
               , goals.value
               , goals.id
        ORDER BY A.year DESC
               , B.month ASC
    }

    sql_table(sql, organization_id: organization_id, from_date: from_date, to_date: to_date)
  end
end
