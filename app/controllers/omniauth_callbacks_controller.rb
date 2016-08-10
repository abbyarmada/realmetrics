class OmniauthCallbacksController < Api::V1::ApiController
  def callback
    case params[:provider]
    when 'stripe_connect' then omniauth_with_stripe_connect
    end
  end

  def failure
    redirect_to "#{app_url}setup"
  end

  private

  def omniauth_with_stripe_connect
    provider = request.env['omniauth.auth']['provider']
    uid = request.env['omniauth.auth']['uid']

    identity = Identity.find_or_create_with_omniauth(current_organization, provider, uid)

    publishable_key = request.env['omniauth.auth']['info']['stripe_publishable_key']
    token = request.env['omniauth.auth']['credentials']['token']
    user_id = request.env['omniauth.auth']['extra']['raw_info']['stripe_user_id']

    identity.update_credentials(publishable_key, token, user_id)

    current_organization.crawl_stripe_data

    redirect_to "#{app_url}home"
  end
end
