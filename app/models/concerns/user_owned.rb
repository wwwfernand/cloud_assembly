# frozen_string_literal: true

module UserOwned
  extend ActiveSupport::Concern
  included do
    scope :owned, ->(user_id) { where(user_id:) }
    scope :latest, -> { order(created_at: :desc) }
  end
end
