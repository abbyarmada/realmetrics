class OrganizationMailer < ActionMailer::Base
  def crawl_completed(organization_id)
    @organization = Organization.find(organization_id)

    mail(to: @organization.user.email,
         subject: 'RealMetrics: Initial crawl completed',
         from: 'RealMetrics <contact@realmetrics.io>',
         date: Time.zone.now,
         template_path: 'organization_mailer',
         template_name: 'crawl_completed')
  end
end
