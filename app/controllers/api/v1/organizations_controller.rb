module Api
  module V1
    class OrganizationsController < Api::V1::ApiController
      before_action :authenticate_user!
      before_action :set_organization, only: [:show, :update, :destroy, :crawl_stripe_data]

      # GET /api/v1/organizations
      def index
        @organizations = current_user.organizations.order('name')
        render json: @organizations.to_json
      end

      # GET /api/v1/organizations/1
      def show
        render json: @organization.to_json
      end

      # POST /api/v1/organizations
      def create
        @organization = current_user.organizations.build(organization_params)

        if @organization.save
          current_organization!(@organization)
          render json: @organization.to_json, status: :created
        else
          render_errors_for @organization
        end
      end

      # PATCH /api/v1/organizations/1
      def update
        if @organization.update(organization_params)
          render json: @organization.to_json
        else
          render_errors_for @organization
        end
      end

      # DELETE /api/v1/organizations/1
      def destroy
        if @organization.destroy
          head :no_content
        else
          render_errors_for @organization
        end
      end

      def crawl_stripe_data
        @organization.crawl_stripe_data
        head :no_content
      end

      private

      def set_organization
        @organization = current_user.organizations.find_by(id: params[:id])
        render json: {}, status: :not_found unless @organization.present?
      end

      def organization_params
        params[:organization].permit(
          :name
        )
      end
    end
  end
end
