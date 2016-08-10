module Api
  module V1
    class CustomersController < Api::V1::ApiController
      before_action :authenticate_user!

      # GET /api/v1/customers
      def index
        @customers = current_organization.stripe_customers.order('email')
        render json: @customers.to_json(format: :list)
      end

      # GET /api/v1/customers/1
      def show
        @customer = current_organization.stripe_customers.find(params[:id])
        render json: @customer.to_json(format: :details)
      end
    end
  end
end
