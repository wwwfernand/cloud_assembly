# frozen_string_literal: true

require 'rails_helper'

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
        let(:value) { target }

        it do
          expect(subject).send({ valid: :to, invalid: :not_to }
                              .fetch(expected), be_valid)
        end
      end
    end
  end
end
