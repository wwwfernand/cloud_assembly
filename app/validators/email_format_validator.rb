# frozen_string_literal: true

# Validate user.email
class EmailFormatValidator < ActiveModel::EachValidator
  EMAIL_REGEXP = /\A[a-z\d.\-_+]+@[a-z\d.\-_+]+\.[a-z]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, :invalid) unless value =~ EMAIL_REGEXP
  end
end
