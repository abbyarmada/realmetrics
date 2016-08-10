module Api
  module V1
    class SessionsController < Api::V1::ApiController
      before_action :authenticate_user!, only: [:show]
      before_action :set_user, only: [:show]

      # GET /api/v1/sessions
      def show
        render json: @user.to_json
      end

      # GET /api/v1/sessions/user
      def user
        render json: current_user.to_json
      end

      # GET /api/v1/sessions/organization
      def organization
        render json: current_organization.to_json
      end

      # POST /sessions
      def create
        user = User.authenticate_with_email_and_password(params[:session][:email], params[:session][:password], request.remote_ip)

        if user.present?
          sign_in!(user)
          render json: current_user.to_json
        else
          render json: { error: 'Invalid email or password.' }, status: 422
        end
      end

      # DELETE /api/v1/sessions
      def destroy
        sign_out!
        head :no_content
      end

      private

      def set_user
        @user = current_user
      end
    end
  end
end
