# frozen_string_literal: true

# Validate user.username
class UsernameFormatValidator < ActiveModel::EachValidator
  USERNAME_REGEXP = /\A[a-zA-Z0-9.-]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, :invalid) unless value =~ USERNAME_REGEXP
  end
end
