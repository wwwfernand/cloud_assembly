# frozen_string_literal: true

require 'rails_helper'

class TestPasswordFormatValidator
  include ActiveModel::Validations

  attr_accessor :password

  validates :password, password_format: true, length: { within: User::MIN_PASSWORD_LENGTH..User::MAX_PASSWORD_LENGTH }

  def initialize(password)
    @password = password
  end
end

describe PasswordFormatValidator, type: :validator do
  #
  # Password format rule
  #
  # * should be only written with ascii character
  # * should be 8 to 24 characters in length
  # * should include at least one alphabetical character
  # * should include at least one numerical character
  # * should include at least one symbol
  # * should include at least one lowercase
  # * should include at least one uppercase
  #
  describe '#validate_each' do
    [
      ['ab#d0C01', :valid],
      ['abcd0101', :invalid],
      ['AaA01010', :invalid],
      ['abcd-101', :invalid],
      ['abcd.101', :invalid],
      ['abcd/001', :invalid],
      ['abcd\001', :invalid],
      ['abcd&001', :invalid],
      ['abcd#001', :invalid],
      ['abcd?001', :invalid],
      ['aaaaaaa1', :invalid],
      ['aaaaaaa1111111111111$A124', :invalid],
      ['◯✕★A01',   :invalid],
      ['777777A',  :invalid],
      ['ｱｲｳｴ001',  :invalid],
      ['aaaaaaaa', :invalid],
      ['10000000', :invalid],
      [10_000_000, :invalid],
      ['--------', :invalid]
    ].each do |target, expected|
      context(target) do
        subject { TestPasswordFormatValidator.new(target).valid? }

        it { is_expected.to be({ valid: true, invalid: false }.fetch(expected)) }
      end
    end
  end
end
