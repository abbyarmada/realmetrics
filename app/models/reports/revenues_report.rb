class RevenuesReport < ReportBase
  attr_accessor :data, :kpis
  after_initialize :render

  private

  def render
    @data = []
    @kpis = {
      ytd: {
        amount: 0,
        goal: 0,
        completion: 0,
        growth: 0
      },
      mtd: {
        amount: 0,
        goal: 0,
        completion: 0,
        growth: 0
      }
    }

    current_year = nil

    results.each do |res|
      current_month = res['month'].to_i

      if current_year != res['year'].to_i
        current_year = res['year'].to_i

        @data << {
          year: res['year'].to_i,
          data: []
        }

        12.times do |idx|
          @data[-1][:data] << {
            month: idx + 1,
            amount: 0,
            goal: 0,
            completion: 0,
            growth: 0
          }
        end
      end

      current_amount = res['amount'].to_i * 1.0
      current_goal = res['goal'].to_i * 1.0
      last_amount = @data[-1][:data][current_month - 2][:amount]

      @data[-1][:data][current_month - 1][:amount] = current_amount
      @data[-1][:data][current_month - 1][:goal] = current_goal
      @data[-1][:data][current_month - 1][:completion] = (current_amount / current_goal * 100.0).round(0) if current_goal > 0
      @data[-1][:data][current_month - 1][:growth] = (current_amount / last_amount * 100.0).round(0) - 100 if last_amount.present? && last_amount > 0 && current_amount > 0

      if current_month == Time.zone.today.month && current_year == Time.zone.today.year
        @kpis[:mtd][:amount] = @data[-1][:data][current_month - 1][:amount]
        @kpis[:mtd][:goal] = @data[-1][:data][current_month - 1][:goal]
        @kpis[:mtd][:completion] = @data[-1][:data][current_month - 1][:completion]
        @kpis[:mtd][:growth] = @data[-1][:data][current_month - 1][:growth]
      end

      if @data[-1][:data][current_month - 1][:amount] > 0
        @kpis[:ytd][:amount] += @data[-1][:data][current_month - 1][:amount]
        @kpis[:ytd][:goal] += @data[-1][:data][current_month - 1][:goal]
      end
    end

    if @kpis[:ytd][:goal] > 0
      @kpis[:ytd][:completion] = (@kpis[:ytd][:amount] / @kpis[:ytd][:goal] * 100.0).round(0)
    end

    # last non null ON first non null
    first_non_null = 0
    last_non_null = 0

    @data[-1][:data].each do |row|
      first_non_null = row[:amount] if row[:amount] > 0 && first_non_null == 0
      last_non_null = row[:amount] if row[:amount] > 0
    end
    first_non_null = 1 if first_non_null == 0

    @kpis[:ytd][:growth] = (last_non_null / first_non_null * 100.0).round(0) - 100
  end

  def results
    sql = %q{
      SELECT A.year
           , B.month
           , SUM(stripe_transactions.gross_amount) AS amount
           , goals.value AS goal
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
