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
  include_context 'with articles mock'

  let(:current_user) { create(:user) }

  describe '.save' do
    context 'when new record' do
      subject { described_class.new(params.merge(user_id: current_user.id)).save(context: state) }

      let(:state) { nil }

      context 'when draft state' do
        context 'when valid data' do
          let(:params) { article_create_valid_params }

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
          let(:params) { article_create_valid_params }

          it { is_expected.to be true }
        end

        context 'when title is missing' do
          let(:params) { article_create_valid_params.merge(title: '') }

          it { is_expected.to be false }
        end
      end

      context 'when future publish state' do
        let(:state) { Article::STATES[:publish_later] }

        context 'when valid data' do
          let(:params) { article_create_valid_params.merge(publish_at: 1.day.from_now) }

          it { is_expected.to be true }
        end

        context 'when publish_at is missing' do
          let(:params) { article_create_valid_params }

          it { is_expected.to be false }
        end

        context 'when publish_at is not future' do
          let(:params) { article_create_valid_params.merge(publish_at: Time.zone.now) }

          it { is_expected.to be false }
        end
      end
    end

    context 'when existing record' do
      subject(:update_article) do
        saved_article.assign_attributes(params)
        saved_article.save(context: state)
      end

      let(:state) { nil }

      context 'when updating draft' do
        let(:saved_article) { create(:article, :draft) }

        context 'when valid data' do
          let(:params) { article_create_valid_params }

          it { is_expected.to be true }

          it 'status is draft' do
            update_article
            saved_article.reload
            expect(saved_article.draft?).to be true
            expect(saved_article.publish_at).to be_nil
          end
        end

        context 'when title is missing' do
          let(:params) { article_create_valid_params.merge(title: '') }

          it { is_expected.to be false }
        end
      end

      context 'when updating scheduled publish' do
        let(:saved_article) { create(:article, :published_later) }

        context 'when valid data' do
          let(:params) { article_create_valid_params }

          it { is_expected.to be true }

          it 'publish status is retained' do
            update_article
            saved_article.reload
            expect(saved_article.draft?).to be true
            expect(saved_article.publish_at).to be_nil
          end
        end
      end

      context 'when updating published' do
        let(:saved_article) { create(:article, :published) }

        context 'when valid data' do
          let(:params) { article_create_valid_params }

          it { is_expected.to be true }

          it 'status becomes revise' do
            update_article
            saved_article.reload
            expect(saved_article.revise?).to be true
            expect(saved_article.publish_at).to be < Time.zone.now
          end
        end
      end
    end
  end
end
