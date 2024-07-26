# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/articles', type: :request do
  include_context 'with articles mock'

  let(:current_user) { create(:user) }

  describe 'GET /index' do
    context 'when logged in' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
        create(:article, user: current_user)
      end

      it 'return current user articles' do
        get member_articles_url
        expect(response).to be_successful
      end
    end

    context 'when not logged in' do
      it 'redirect to root url' do
        get member_articles_url
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get articles_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    context 'when logged in' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
      end

      context 'when own article' do
        let(:article) { create(:article, user_id: current_user.id) }

        it 'renders a successful response' do
          get edit_member_article_url(article)
          expect(response).to be_successful
        end
      end

      context "when other user's article" do
        let(:article) { create(:article) }

        it 'renders a not_found response' do
          get edit_member_article_url(article)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not logged in' do
      let(:article) { create(:article, user_id: current_user.id) }

      it 'redirect to root url' do
        get edit_member_article_url(article)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST /create' do
    context 'when logged in' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
      end

      context 'with valid parameters' do
        it 'creates a new Article' do
          expect do
            post articles_url, params: { article: article_create_valid_params }
          end.to change(Article, :count).by(1)
        end

        it 'renders a successful response' do
          post articles_url, params: { article: article_create_valid_params }
          expect(response).to be_successful
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            image_link: 'invalid URL'
          }
        end

        it 'does not create a new Article' do
          expect do
            post articles_url, params: { article: invalid_params }
          end.not_to change(Article, :count)
        end

        it 'renders a response with 422 status' do
          post articles_url, params: { article: invalid_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not logged in' do
      it 'does not create a new Article' do
        expect do
          post articles_url, params: { article: article_create_valid_params }
        end.not_to change(Article, :count)
      end

      it 'renders a forbidden response' do
        post articles_url, params: { article: article_create_valid_params }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when logged in' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
      end

      context 'with valid parameters' do
        let(:new_attributes) do
          {
            title: 'new title'
          }
        end

        it 'updates the requested article' do
          article = create(:article, user: current_user)
          patch member_article_url(article), params: { article: new_attributes }
          article.reload
          expect(article.title).to eq(new_attributes[:title])
        end

        it 'renders a successful response' do
          article = create(:article, user: current_user)
          patch member_article_url(article), params: { article: new_attributes }
          expect(response).to be_successful
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) do
          {
            image_link: 'invalid url'
          }
        end

        it 'renders a response with 422 status' do
          article = create(:article, user: current_user)
          patch member_article_url(article), params: { article: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not logged in' do
      let(:new_attributes) do
        {
          title: 'new title'
        }
      end

      it 'renders a forbidden response' do
        article = create(:article)
        patch member_article_url(article), params: { article: new_attributes }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
