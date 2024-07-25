# frozen_string_literal: true

# Validate user.password
class PasswordFormatValidator < ActiveModel::EachValidator
  PASSWORD_REGEXP = /\A
    (?=.*\d) # at least one number
    (?=.*[a-z]) # at least one lowercase
    (?=.*[A-Z]) # at least one uppercase
    (?=.*[[:^alnum:]]) # at least one symbol
  /x

  PASSWORD_INVALID_MSG = 'must include lower and upper case letters, '\
    'and at least one number and symbol'

  def validate_each(record, attribute, value)
    return if value.blank?
    return if value =~ PASSWORD_REGEXP

    record.errors.add(attribute, PASSWORD_INVALID_MSG)
  end
end
