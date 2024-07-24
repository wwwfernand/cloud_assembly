# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def site_name
    @site_name ||= Rails.application.credentials.app_name
  end

  def site_root_url
    @site_root_url ||= Rails.application.credentials.app_root_url
  end

  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end

  def datetime_str(datetime)
    datetime.strftime('%b %d, %Y')
  end
end
