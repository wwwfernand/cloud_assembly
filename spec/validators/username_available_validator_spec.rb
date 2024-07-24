# frozen_string_literal: true

require 'rails_helper'

describe UsernameAvailabeValidator, type: :validator do
  describe '#validate_each' do
    [
      ['alphanumeric', 'abcd0101',   :valid],
      ['numeric',      '02142',      :valid],
      ['upcase',       'AAA0101',    :valid],
      ['camelcase',    'AaA0101',    :valid],
      ['-',            'abcd-101',   :valid],
      ['.',            'abcd.101',   :valid],
      ['non-ascii',    '◯✕★A',       :invalid],
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

  context 'unique' do
    let!(:attribute_names) { %i[buyma_user_id value] }
    let!(:user_a) do
      create(:user, username: 'username_a')
    end
    let!(:reserved_username_a) do
      create(:reserved_username, username: 'reserved_username_a',
                                 buyma_user_id: 10)
    end
    let!(:username_available) { 'username_b' }

    context 'valid' do
      context 'valid' do
        let(:buyma_user_id) { nil }
        let(:username) { username_available }
        let(:value) { username }

        it { is_expected.to be_valid }
      end

      context 'valid' do
        let(:buyma_user_id) { 10 }
        let(:value) { reserved_username_a.username }

        it { is_expected.to be_valid }
      end
    end

    context 'invalid' do
      context 'invalid' do
        let(:buyma_user_id) { nil }
        let(:value) { reserved_username_a.username }

        it { is_expected.to be_invalid }
      end

      context 'invalid' do
        let(:buyma_user_id) { 100 }
        let(:value) { reserved_username_a.username }

        it { is_expected.to be_invalid }
      end

      context 'invalid' do
        let(:buyma_user_id) { nil }
        let(:value) { user_a.username }

        it { is_expected.to be_invalid }
      end
    end
  end
end
