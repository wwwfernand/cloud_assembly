# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :uuid             not null, primary key
#  image_link :string
#  publish_at :datetime
#  rank       :integer          default(0)
#  status     :integer          default(0), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
FactoryBot.define do
  factory :article do
    title { Faker::Quote.matz }
    tag_list { Faker::Lorem.words.join(' ') }
    image_link { Faker::Avatar.image }
    status { :draft }
    draft_section { build(:article_section, :draft) }
    association :user

    trait :published do
      status { :published }
      publish_section { build(:article_section, :publish) }
      publish_at { Time.zone.now }
    end

    trait :draft do
      status { :draft }
    end

    trait :published_later do
      status { :published }
      publish_section { build(:article_section, :publish) }
      publish_at { 2.days.from_now }
    end

    trait :revise do
      status { :revise }
      publish_section { build(:article_section, :publish) }
      publish_at { Time.zone.now }
    end
  end
end
