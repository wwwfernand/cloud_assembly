# frozen_string_literal: true

module Assembly
  module Images
    class MultipleUpload
      attr_reader :errors

      def initialize(images, user_id)
        @images = images
        @user_id = user_id
        @errors = []
      end

      def run
        @images.map { |img| upload(img) }.compact.flatten
      end

      private

      def upload(img)
        return nil if img.blank?

        UserImage.transaction do
          UserImage.create(image: img, user_id: @user_id)
        end
      rescue StandardError => e
        Rails.logger.error("#{self.class.name}.#{__method__} Exception: #{e}")
        errors << "#{img.original_filename} is invalid image file"
        nil
      end
    end
  end
end
