require 'factory_girl'

module ControllersMacros
  def create_and_login_user
    user = FactoryGirl.create(:user)
    request.session[:user_id] = user.id
  end
end
