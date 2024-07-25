# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :uuid             not null, primary key
#  image_link :string
#  publish_at :datetime
#  rank       :integer          default(0)
#  status     :integer          default("draft"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  include_context 'articles_mock_context'

  describe '.valid?' do
    context 'when new record' do
      subject { described_class.new(params).valid?(context: state) }

      let(:state) { nil }

      context 'when draft state' do
        context 'when valid data' do
          let(:params) { articles_mock_context }

          it { is_expected.to be true }
        end

        context 'when title is missing' do
          let(:params) { { image_link: Faker::Avatar.image } }

          it { is_expected.to be false }
        end
      end

      context 'when publish state' do
        let(:state) { Article::STATES[:publish_now] }

        context 'when valid data' do
          let(:params) { articles_mock_context }

          it { is_expected.to be true }
        end

        context 'when title is missing' do
          let(:params) { articles_mock_context.merge(title: '') }

          it { is_expected.to be false }
        end
      end

      context 'when future publish state' do
        let(:state) { Article::STATES[:publish_later] }

        context 'when valid data' do
          let(:params) { articles_mock_context.merge(publish_at: 1.day.from_now) }

          it { is_expected.to be true }
        end

        context 'when publish_at is missing' do
          let(:params) { articles_mock_context }

          it { is_expected.to be false }
        end

        context 'when publish_at is not future' do
          let(:params) { articles_mock_context.merge(publish_at: Time.zone.now) }

          it { is_expected.to be false }
        end
      end
    end
  end
end
