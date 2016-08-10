module Api
  module V1
    class ReportsController < Api::V1::ApiController
      before_action :authenticate_user!

      # GET /api/v1/reports/revenues
      def revenues
        @report = RevenuesReport.new(report_params)

        render json: { data: @report.data, kpis: @report.kpis }.to_json
      end

      # GET /api/v1/reports/customers
      def customers
        @report = CustomersReport.new(report_params)

        render json: { data: @report.data, kpis: @report.kpis }.to_json
      end

      # GET /api/v1/reports/subscriptions
      def subscriptions
        @report = SubscriptionsReport.new(report_params)

        render json: { data: @report.data }.to_json
      end

      private

      def report_params
        {
          organization_id: current_organization.id,
          from_date: Date.new(Time.zone.today.year, 1, 1),
          to_date: Date.new(Time.zone.today.year, 12, 31)
        }
      end
    end
  end
end
