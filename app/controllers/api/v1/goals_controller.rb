module Api
  module V1
    class GoalsController < Api::V1::ApiController
      before_action :authenticate_user!
      before_action :set_goal, only: [:show, :update, :destroy]

      # GET /api/v1/goals
      def index
        @goals = current_organization.goals.order('year, month')
        @goals = @goals.where(metric: params['metric']) if params[:metric].present?

        render json: @goals.to_json
      end

      # GET /api/v1/goals/1
      def show
        render json: @goal.to_json
      end

      # POST /api/v1/goals
      def create
        @goal = current_organization.goals.build(goal_params)

        if @goal.save
          render json: @goal.to_json, status: :created
        else
          render_errors_for @goal
        end
      end

      # PATCH /api/v1/goals/1
      def update
        if @goal.update(goal_params)
          render json: @goal.to_json
        else
          render_errors_for @goal
        end
      end

      # DELETE /api/v1/goals/1
      def destroy
        if @goal.destroy
          head :no_content
        else
          render_errors_for @goal
        end
      end

      def batch_upsert
        params[:goals].each do |goal|
          current_organization.goals.find_or_initialize_by(
            year: goal[:year],
            month: goal[:month],
            metric: goal[:metric]
          ).update_attributes(
            value: goal[:value]
          )
        end

        render json: { success: true }, status: :created
      end

      def set_goals
        current_organization.set_goals(
          goal_params[:year].to_i,
          goal_params[:month].to_i,
          goal_params[:metric],
          goal_params[:value].to_i,
          goal_params[:growth].to_i
        )

        render json: { success: true }, status: :created
      end

      private

      def set_goal
        @goal = current_organization.goals.find_by(id: params[:id])
        render json: {}, status: :not_found unless @goal.present?
      end

      def goal_params
        params[:goal].permit(
          :year,
          :month,
          :value,
          :metric,
          :growth
        )
      end
    end
  end
end
