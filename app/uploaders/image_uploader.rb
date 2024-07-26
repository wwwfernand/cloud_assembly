# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      thumbnail: magick.resize_to_limit!(300, 300)
    }
  end

  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record

    id     = record.id
    prefix = derivative || 'original'

    "d/#{record.user_id}/#{id}/#{prefix}-#{super}"
  end
end
