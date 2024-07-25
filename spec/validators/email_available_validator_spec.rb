# frozen_string_literal: true

require 'rails_helper'

describe EmailFormatValidator, type: :validator do
  describe '#validate_each' do
    [
      ['valid',        Faker::Internet.email,   :valid],
      ['alphanumeric', 'abcd0101',              :invalid],
      ['numeric',      '02142',                 :invalid]
    ].each do |ctx, target, expected|
      context(ctx) do
        let(:value) { target }

        it do
          expect(subject).send({ valid: :to, invalid: :not_to }
                              .fetch(expected), be_valid)
        end
      end
    end
  end
end
