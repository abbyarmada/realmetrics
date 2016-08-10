module Api
  module V1
    class PlansController < Api::V1::ApiController
      before_action :authenticate_user!

      # GET /api/v1/plans
      def index
        @plans = current_organization.stripe_plans.where('interval IS NOT NULL').order('name')
        render json: @plans.to_json
      end
    end
  end
end
