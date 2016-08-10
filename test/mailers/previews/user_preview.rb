class UserPreview < ActionMailer::Preview
  def new_user
    UserMailer.new_user(1)
  end

  def new_password
    UserMailer.new_password(1)
  end

  def change_email
    UserMailer.change_email(1)
  end
end
