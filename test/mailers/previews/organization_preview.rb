class OrganizationPreview < ActionMailer::Preview
  def crawl_completed
    OrganizationMailer.crawl_completed(1)
  end
end
