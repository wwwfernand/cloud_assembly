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
class UserImage < ApplicationRecord
  include UserOwned
  include ImageUploader::Attachment(:image)

  belongs_to :user, inverse_of: :user_images
end
