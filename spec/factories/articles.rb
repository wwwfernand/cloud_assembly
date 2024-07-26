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
FactoryBot.define do
  factory :article do
    title { Faker::Quote.matz }
    tag_list { Faker::Lorem.words.join(' ') }
    image_link { Faker::Avatar.image }
    status { :draft }
    association :draft_section, :draft, factory: :article_section, strategy: :build
    association :user

    trait :published do
      status { :published }
      association :publish_section, :publish, factory: :article_section, strategy: :build
      publish_at { Time.zone.now }
    end

    trait :draft do
      status { :draft }
    end

    trait :published_later do
      status { :published }
      association :publish_section, :publish, factory: :article_section, strategy: :build
      publish_at { 2.days.from_now }
    end

    trait :revise do
      status { :revise }
      association :publish_section, :publish, factory: :article_section, strategy: :build
      publish_at { Time.zone.now }
    end
  end
end
