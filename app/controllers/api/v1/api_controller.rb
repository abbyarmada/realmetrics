module Api
  module V1
    class ApiController < ActionController::Base
      def current_user
        return nil unless signed_in?
        user = User.find_by(id: session[:user_id])
        sign_out! unless user.present?
        user
      end
      helper_method :current_user

      def signed_in?
        session[:user_id].present?
      end
      helper_method :signed_in?

      def sign_in!(user)
        session[:user_id] = user.id
        session[:organization_id] = user.organizations.first.id if user.organizations.any?
      end
      helper_method :sign_in!

      def sign_out!
        session[:user_id] = nil
        session[:organization_id] = nil
      end
      helper_method :sign_out!

      def current_organization
        return nil unless session[:organization_id].present?
        organization = Organization.find_by(id: session[:organization_id])
        session[:organization_id] = nil unless organization.present? && organization.user == current_user
        organization
      end
      helper_method :current_organization

      def current_organization!(organization)
        session[:organization_id] = organization.id
      end
      helper_method :current_organization!

      private

      def authenticate_user!
        render json: { error: 'Not authorized.' }, status: 401 unless signed_in?
      end

      def render_errors_for(object)
        render json: object.errors.to_json, status: :unprocessable_entity
      end
    end
  end
end
