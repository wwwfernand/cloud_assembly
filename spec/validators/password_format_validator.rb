# frozen_string_literal: true

require 'rails_helper'

describe PasswordFormatValidator, type: :validator do
  #
  # Password format rule
  #
  # * should be only written with ascii character
  # * should be 8 to 20 characters in length
  # * should include at least one alphabetical character
  # * should include at least one numerical character
  #
  describe '#validate_each' do
    [
      ['abcd0101', :valid],
      ['AAA01010', :valid],
      ['AaA01010', :valid],
      ['abcd-101', :valid],
      ['abcd.101', :valid],
      ['abcd/001', :valid],
      ['abcd\001', :valid],
      ['abcd&001', :valid],
      ['abcd#001', :valid],
      ['abcd?001', :valid],
      ['aaaaaaa1', :valid],
      ['aaaaaaa1111111111111', :valid],
      ['◯✕★A01',   :invalid],
      ['777777A',  :invalid],
      ['ｱｲｳｴ001',  :invalid],
      ['aaaaaaaa', :invalid],
      ['10000000', :invalid],
      [10_000_000, :invalid],
      ['--------', :invalid],
      ['AAAAAAA-100000000000000000000000000000', :invalid],
      ['◯✕★A', :invalid]
    ].each do |target, expected|
      context(target) do
        let(:value) { target }

        it do
          expect(subject).send({ valid: :to, invalid: :not_to }
                               .fetch(expected), be_valid)
        end
      end
    end
  end
end
