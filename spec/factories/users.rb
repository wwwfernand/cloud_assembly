# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :uuid             not null, primary key
#  active              :boolean          default(FALSE)
#  approved            :boolean          default(FALSE)
#  avatar_link         :string
#  confirmed           :boolean          default(FALSE)
#  crypted_password    :string
#  current_login_at    :datetime
#  current_login_ip    :string
#  email               :string
#  failed_login_count  :integer          default(0), not null
#  last_login_at       :datetime
#  last_login_ip       :string
#  last_request_at     :datetime
#  login_count         :integer          default(0), not null
#  password_salt       :string
#  perishable_token    :string
#  persistence_token   :string
#  single_access_token :string
#  username            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email                (email) UNIQUE
#  index_users_on_perishable_token     (perishable_token) UNIQUE
#  index_users_on_persistence_token    (persistence_token) UNIQUE
#  index_users_on_single_access_token  (single_access_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    username { Faker::Alphanumeric.alpha(number: 4) }
    email { Faker::Internet.email }
    password { 'hY5l%V2x' }
  end
end
