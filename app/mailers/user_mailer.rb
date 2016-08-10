class UserMailer < ActionMailer::Base
  def new_user(user_id)
    @user = User.find(user_id)

    mail(to: @user.email,
         subject: 'Welcome to RealMetrics!',
         from: 'RealMetrics <contact@realmetrics.io>',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_user')
  end

  def new_password(user_id)
    @user = User.find(user_id)

    mail(to: @user.email,
         subject: 'RealMetrics: password reset request',
         from: 'RealMetrics <contact@realmetrics.io>',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'new_password')
  end

  def change_email(user_id)
    @user = User.find(user_id)

    mail(to: @user.unconfirmed_email,
         subject: 'RealMetrics: change email request',
         from: 'RealMetrics <contact@realmetrics.io>',
         date: Time.zone.now,
         template_path: 'user_mailer',
         template_name: 'change_email')
  end
end
