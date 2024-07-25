# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module JSON
  module Errors
    class Error < StandardError
      attr_accessor :errors

      def error_type
        self.class.name.demodulize
      end
    end

    class InvalidRequestError < Error
    end

    class ProcessError < Error; end

    module ErrorRepresenter
      include Roar::JSON

      property :error_type, skip_parse: true
      property :message, skip_parse: true
      property :errors
    end

    def self.from_exception(error:, object: nil)
      if object&.errors.present?
        api_error = InvalidRequestError.new('Validation failed for request')
        api_error.errors = object.errors.to_hash(true)
      else
        api_error = ProcessError.new(error.message)
      end
      api_error.extend(ErrorRepresenter)
      api_error
    end

    def self.from_message(message:, error_class: InvalidRequestError)
      api_error = error_class.new(message)
      api_error.errors = { base: ['something went wrong'] }
      api_error.extend(ErrorRepresenter)
      api_error
    end

    def self.from_json(json)
      hash = JSON.parse(json)
      api_class = Errors.const_get(hash['error_type'])
      api_class.new(hash['description']).extend(ErrorRepresenter).from_json(json)
    end
  end
end
