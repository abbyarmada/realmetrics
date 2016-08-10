module Api
  module V1
    class IdentitiesController < Api::V1::ApiController
      before_action :authenticate_user!
      before_action :set_identity, only: [:destroy]

      # DELETE /api/v1/identities/1
      def destroy
        if @identity.destroy
          head :no_content
        else
          render_errors_for @identity
        end
      end

      private

      def set_identity
        @identity = current_organization.identities.find_by(id: params[:id])
        render json: {}, status: :not_found unless @identity.present?
      end
    end
  end
end
