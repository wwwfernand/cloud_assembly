# frozen_string_literal: true

shared_context 'with articles mock' do
  let(:article_create_valid_params) do
    {
      draft_section_attributes: {
        html_body: Faker::HTML.paragraph
      },
      title: Faker::Quote.matz,
      tag_list: Faker::Lorem.words.join(' '),
      image_link: Faker::Avatar.image
    }
  end
end
