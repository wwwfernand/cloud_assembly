# frozen_string_literal: true

# == Schema Information
#
# Table name: user_images
#
#  id         :uuid             not null, primary key
#  image_data :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_user_images_on_image_data  (image_data) USING gin
#  index_user_images_on_user_id     (user_id)
#
FactoryBot.define do
  factory :user_image do
    image_data do
      {
        id: Faker::File.file_name(dir: 'd/'),
        storage: 'store',
        metadata: { size: 500_000, filename: Faker::File.file_name, mime_type: 'image/png' },
        derivatives: {
          thumbnail: {
            id: Faker::File.file_name(dir: 'd/'),
            storage: 'store',
            metadata: { size: 50_000, filename: Faker::File.file_name, mime_type: nil }
          }
        }
      }
    end
  end
end
