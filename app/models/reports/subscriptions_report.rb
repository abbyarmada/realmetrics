class SubscriptionsReport < ReportBase
  attr_accessor :data
  after_initialize :render

  private

  def render
  end

  def results
    sql = %q{
      SELECT A.year
           , B.month
           , (SELECT COUNT(1)
                FROM stripe_subscriptions
               WHERE stripe_subscriptions.organization_id = 1
                 AND ( TO_DATE(A.year ||'-'|| B.month + 1 || '-01', 'YYYY-MM-DD') - INTERVAL '1 day' BETWEEN started_at AND ended_at
                       OR
                       (TO_DATE(A.year ||'-'|| B.month + 1 || '-01', 'YYYY-MM-DD') - INTERVAL '1 day' > started_at AND ended_at IS NULL)
                     )
             ) AS subscriptions_count
           , goals.value AS goal
           , goals.id AS goal_id
        FROM (SELECT generate_series(
                       CAST(EXTRACT(YEAR FROM :from_date::DATE) AS INTEGER),
                       CAST(EXTRACT(YEAR FROM :to_date::DATE) AS INTEGER)
              ) AS year) A
        JOIN (SELECT generate_series(1, 12) AS month) B ON A.year != B.month
        LEFT JOIN goals ON goals.organization_id = :organization_id
                       AND goals.year = A.year
                       AND goals.month = B.month
                       AND goals.metric = 'subscription'
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
