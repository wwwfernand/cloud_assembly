# frozen_string_literal: true

require 'rails_helper'

class TestEmailFormatValidator
  include ActiveModel::Validations

  attr_accessor :email

  validates :email, email_format: true

  def initialize(email)
    @email = email
  end
end

describe EmailFormatValidator, type: :validator do
  describe '#validate_each' do
    [
      ['valid',        Faker::Internet.email,   :valid],
      ['alphanumeric', 'abcd0101',              :invalid],
      ['numeric',      '02142',                 :invalid]
    ].each do |ctx, target, expected|
      context(ctx) do
        subject { TestEmailFormatValidator.new(target).valid? }

        it { is_expected.to be({ valid: true, invalid: false }.fetch(expected)) }
      end
    end
  end
end
