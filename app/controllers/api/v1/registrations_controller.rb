module Api
  module V1
    class RegistrationsController < Api::V1::ApiController
      before_action :authenticate_user!, only: [:show, :update]
      before_action :set_user, only: [:show, :update]

      # GET /registrations
      def show
        render json: @user.to_json
      end

      def create_account
        user = User.new(user_params)

        if user.save
          sign_in!(user)
          redirect_to "#{app_url}setup"
        else
          redirect_to website_url
        end
      end

      # POST /registrations
      def create
        user = User.new(user_params)

        if user.save
          sign_in!(user)
          render json: { success: true }
        elsif User.find_by(email: user_params[:email]).present?
          render json: { error: 'Email is already in use.' }, status: 422
        else
          render_errors_for user
        end
      end

      # PATCH /registrations/confirm
      def confirm
        user = User.find_by(confirmation_token: params[:token])

        if user.present?
          user.confirm!
          render json: { success: true }
        else
          render json: { error: 'Invalid confirmation token.' }, status: 422
        end
      end

      # PATCH /registrations
      def update
        if can_update? && @user.update(user_params)
          render json: @user.to_json
        else
          render_errors_for @user
        end
      end

      private

      def set_user
        @user = current_user
      end

      def user_params
        params[:user].permit(
          :email,
          :password
        )
      end

      def can_update?
        result = true

        if params[:user][:password].present?
          result = false unless @user.can_update_password(params[:user][:current_password])
        end

        if params[:user][:email].present? && params[:user][:email] != @user.email
          if User.find_by(email: params[:user][:email]).present?
            result = false
          else
            @user.change_email!(params[:user][:email])
            params[:user][:email] = @user.email
          end
        end

        result
      end
    end
  end
end
