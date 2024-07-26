# frozen_string_literal: true

# Validate url strings
class HttpUrlValidator < ActiveModel::EachValidator
  def self.compliant?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    return if value.present? && self.class.compliant?(value)

    record.errors.add(attribute, 'is not a valid link')
  end
end
