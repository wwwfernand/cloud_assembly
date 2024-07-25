# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/drafts', type: :request do
  let(:current_user) { create(:user) }

  describe 'GET /show' do
    context 'when draft article' do
      it 'shows current user article' do
        article = create(:article, user: current_user)
        get draft_article_url(article)
        expect(response).to be_successful
      end

      it 'allow access other user article' do
        article = create(:article)
        get draft_article_url(article)
        expect(response).to be_successful
      end
    end

    context 'when revise article' do
      it 'shows current user article' do
        article = create(:article, :revise, user: current_user)
        get draft_article_url(article)
        expect(response).to be_successful
      end
    end

    context 'when published article' do
      it 'redirect to published article path' do
        article = create(:article, :published, user: current_user)
        get draft_article_url(article)
        expect(response).to redirect_to(show_article_url(article))
      end
    end
  end
end
