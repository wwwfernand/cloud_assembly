# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module JSON
  class UserImageRepresenter < Roar::Decorator
    include Roar::JSON

    property :image_link
    property :thumbnail_link
    property :filename
  end
end
