class StripeCrawler
  #
  # Class methods
  #

  # Crawl Stripe for organization data.
  #
  # @param [Organization] organization to fetch data for.
  # @return [Boolean] True if the organization was successfully updated, false otherwise.
  def self.crawl(organization)
    return if organization.initial_crawl_completed?

    # organization.update_attribute(:initial_crawl_completed, false)
    # clear_current_data(organization)
    import_data(organization)
    organization.update_attribute(:initial_crawl_completed, true)
    OrganizationMailer.crawl_completed(organization.id).deliver_later
  end

  #
  # Private class methods
  #

  def self.clear_current_data(organization)
    StripeCoupon.where(organization_id: organization.id).delete_all
    StripeCustomer.where(organization_id: organization.id).delete_all
    StripeSubscription.where(organization_id: organization.id).delete_all
    StripeDiscount.where(organization_id: organization.id).delete_all
    StripePlan.where(organization_id: organization.id).delete_all
    StripeTransaction.where(organization_id: organization.id).delete_all
    StripeEvent.where(organization_id: organization.id).delete_all
  end

  def self.import_data(organization)
    stripe_user_id = organization.stripe.user_id

    events, subscriptions, customers, plans = crawl_events(organization, stripe_user_id)

    StripeEvent.import events, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeEvent.key_fields, columns: StripeEvent.data_fields }
    StripeSubscription.import subscriptions, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeSubscription.key_fields, columns: StripeSubscription.data_fields }
    StripeCustomer.import customers, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeCustomer.key_fields, columns: StripeCustomer.data_fields }
    StripePlan.import plans, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripePlan.key_fields, columns: StripePlan.data_fields }

    coupons = crawl_coupons(organization, stripe_user_id)
    customers, subscriptions, discounts = crawl_customers(organization, stripe_user_id)
    plans = crawl_plans(organization, stripe_user_id)
    transactions = crawl_transactions(organization, stripe_user_id)

    StripeCoupon.import coupons, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeCoupon.key_fields, columns: StripeCoupon.data_fields }
    StripeCustomer.import customers, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeCustomer.key_fields, columns: StripeCustomer.data_fields }
    StripeSubscription.import subscriptions, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeSubscription.key_fields, columns: StripeSubscription.data_fields }
    StripeDiscount.import discounts, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeDiscount.key_fields, columns: StripeDiscount.data_fields }
    StripePlan.import plans, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripePlan.key_fields, columns: StripePlan.data_fields }
    StripeTransaction.import transactions, validate: false, batch_size: 1000, on_duplicate_key_update: { conflict_target: StripeTransaction.key_fields, columns: StripeTransaction.data_fields }
  end

  def self.crawl_stripe_object(stripe_object_name, stripe_user_id, extra_args = {})
    starting_after = nil
    list = []

    loop do
      results = "Stripe::#{stripe_object_name}".constantize.all(
        { limit: 100, starting_after: starting_after }.merge(extra_args),
        stripe_account: stripe_user_id
      )
      break if results.data.empty?
      list += results.data
      starting_after = results.data.last.id
    end

    list
  end

  # Fetch coupons from Stripe API and process them.
  #
  # @param [Organization] organization for which to fetch coupons.
  # @return [Integer] Number of processed coupons.
  def self.crawl_coupons(organization, stripe_user_id)
    stripe_coupons = crawl_stripe_object('Coupon', stripe_user_id)
    coupons = []

    stripe_coupons.each do |coupon_data|
      coupons << StripeCoupon.build_from_stripe(organization, coupon_data)
    end

    coupons
  end
  private_class_method :crawl_coupons

  # Fetch customers from Stripe API and process them.
  #
  # @param [Organization] organization for which to fetch customers.
  # @return [Integer] Number of processed customers.
  def self.crawl_customers(organization, stripe_user_id)
    stripe_customers = crawl_stripe_object('Customer', stripe_user_id)
    customers = []
    subscriptions = []
    discounts = []

    stripe_customers.each do |customer_data|
      customers << StripeCustomer.build_from_stripe(organization, customer_data)

      customer_data['subscriptions']['data'].each do |subscription_data|
        subscriptions << StripeSubscription.build_from_stripe(organization, subscription_data)
      end

      discounts << StripeDiscount.build_from_stripe(organization, customer_data['discount']) if customer_data['discount'].present?
    end

    [customers, subscriptions, discounts]
  end
  private_class_method :crawl_customers

  # Fetch events from Stripe API and process them.
  #
  # @param [Organization] organization for which to fetch events.
  # @return [Integer] Number of processed events.
  def self.crawl_events(organization, stripe_user_id)
    stripe_events = []
    events = []
    subscriptions = []
    customers = []
    plans = []

    StripeConfiguration.watched_events.each do |event_type|
      stripe_events.concat crawl_stripe_object('Event', stripe_user_id, type: event_type)
    end

    stripe_events.each do |event_data|
      next if event_data == []
      data = event_data
      data = data.first while data.is_a?(Array)
      next if data.nil?

      events << StripeEvent.build_from_stripe(organization, data)

      if StripeConfiguration.subscription_event?(data['type'])
        subscriptions << StripeSubscription.build_from_stripe(organization, data['data']['object'])
      elsif StripeConfiguration.customer_event?(data['type'])
        customers << StripeCustomer.build_from_stripe(organization, data['data']['object'])
      elsif StripeConfiguration.plan_event?(data['type'])
        plans << StripePlan.build_from_stripe(organization, data['data']['object'])
      end

      StripeEvent.handle(organization, data['type'], data['data']['object'])
    end

    [events, subscriptions, customers, plans]
  end
  private_class_method :crawl_events

  # Fetch plans from Stripe API and process them.
  #
  # @param [Organization] organization for which to fetch plans.
  # @return [Integer] Number of processed plans.
  def self.crawl_plans(organization, stripe_user_id)
    stripe_plans = crawl_stripe_object('Plan', stripe_user_id)
    plans = []

    stripe_plans.each do |plan_data|
      plans << StripePlan.build_from_stripe(organization, plan_data)
    end

    plans
  end
  private_class_method :crawl_plans

  # Fetch transactions from Stripe API and process them.
  #
  # @param [Organization] organization for which to fetch transactions.
  # @return [Integer] Number of processed transactions.
  def self.crawl_transactions(organization, stripe_user_id)
    stripe_transactions = crawl_stripe_object('BalanceTransaction', stripe_user_id)
    transactions = []

    stripe_transactions.each do |transaction_data|
      transactions << StripeTransaction.build_from_stripe(organization, transaction_data)
    end

    transactions
  end
  private_class_method :crawl_transactions
end
