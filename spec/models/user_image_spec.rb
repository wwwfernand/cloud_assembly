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
require 'rails_helper'

RSpec.describe UserImage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
