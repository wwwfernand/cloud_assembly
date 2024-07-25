# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/articles', type: :request do
  include_context 'articles_mock_context'

  # This should return the minimal set of attributes required to create a valid
  # Article. As you add validations to Article, be sure to
  # adjust the attributes here as well.
  describe 'GET /show' do
    context 'when article exists' do
      it 'renders a successful response' do
        article = Article.create! article_create_valid_params
        get show_article_url(article)
        expect(response).to be_successful
      end
    end

    context 'when article does not exists' do
      it 'redirect to root path' do
        get show_article_url(Faker::Internet.uuid)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end