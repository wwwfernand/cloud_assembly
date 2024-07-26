# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/drafts', type: :request do
  describe 'GET /show' do
    context 'when draft article' do
      it 'shows user article regardless of owner' do
        article = create(:article)
        get draft_article_url(article)
        expect(response).to be_successful
      end
    end

    context 'when revise article' do
      it 'shows current user article' do
        article = create(:article, :revise)
        get draft_article_url(article)
        expect(response).to be_successful
      end
    end

    context 'when published article' do
      it 'redirect to published article path' do
        article = create(:article, :published)
        get draft_article_url(article)
        expect(response).to redirect_to(show_article_url(article))
      end
    end

    context 'when scheduled published article' do
      it 'redirect to published article path' do
        article = create(:article, :published_later)
        get draft_article_url(article)
        expect(response).to be_successful
      end
    end
  end
end
