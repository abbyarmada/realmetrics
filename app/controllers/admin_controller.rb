class AdminController < ActionController::Base
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  layout 'admin'

  def dashboard
  end

  def users
  end

  def connect_as
    user = User.find(params[:id])
    sign_in_as_user!(user)
    redirect_to app_url
  end

  def crawl
    user = User.find(params[:id])
    user.organizations.first.crawl_stripe_data if user.organizations.any?
    redirect_to admin_users_path
  end

  private

  def sign_in_as_user!(user)
    session[:user_id] = user.id
    session[:organization_id] = user.organizations.first.id if user.organizations.any?
  end
end
