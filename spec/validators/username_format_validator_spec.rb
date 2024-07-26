# frozen_string_literal: true

require 'rails_helper'

class TestUsernameFormatValidator
  include ActiveModel::Validations

  attr_accessor :username

  validates :username, username_format: true

  def initialize(username)
    @username = username
  end
end

describe UsernameFormatValidator, type: :validator do
  describe '#validate_each' do
    [
      ['alphanumeric', 'abcd0101',   :valid],
      ['numeric',      '02142',      :valid],
      ['upcase',       'AAA0101',    :valid],
      ['camelcase',    'AaA0101',    :valid],
      ['-',            'abcd-101',   :valid],
      ['.',            'abcd.101',   :valid],
      ['non-ascii',    '◯✕★A', :invalid],
      ['/',            'abcd/001',   :invalid],
      ['\\',           'abcd\001',   :invalid],
      ['&',            'abcd&001',   :invalid],
      ['#',            'abcd#001',   :invalid],
      ['?',            'abcd?001',   :invalid]
    ].each do |ctx, target, expected|
      context(ctx) do
        subject { TestUsernameFormatValidator.new(target).valid? }

        it { is_expected.to be({ valid: true, invalid: false }.fetch(expected)) }
      end
    end
  end
end
