class PagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  end

  def app
    render layout: nil
  end
end
