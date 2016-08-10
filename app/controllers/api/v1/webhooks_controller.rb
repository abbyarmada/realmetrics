module Api
  module V1
    class WebhooksController < Api::V1::ApiController
      skip_before_action :verify_authenticity_token

      # GET /api/v1/webhooks/stripe
      def stripe
        StripeWebhook.execute(params.stringify_keys)
        render nothing: true, status: 200, content_type: 'text/html'
      end
    end
  end
end
