module Api
  module V1
    class PasswordsController < Api::V1::ApiController
      # POST /passwords
      def create
        user = User.find_by(email: params[:email])

        if user.present?
          user.send_reset_password_instructions
          render json: { success: true }
        else
          render json: { error: 'Email not found.' }, status: 422
        end
      end

      # PATCH /passwords
      def update
        user = User.reset_password_with_token(params[:reset_password_token], params[:password])

        if user.present?
          sign_in!(user)
          render json: { success: true }
        elsif params[:password].present?
          render json: { error: 'Invalid reset token.' }, status: 422
        else
          render json: { error: 'Invalid password.' }, status: 422
        end
      end
    end
  end
end
