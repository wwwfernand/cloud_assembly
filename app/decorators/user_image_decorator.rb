# frozen_string_literal: true

class UserImageDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def thumbnail_link
    object.image_url(:thumbnail)
  end

  def filename
    object.image_data['metadata']['filename']
  end

  def image_link
    "#{h.site_root_url}#{object.image_url}"
  end
end
