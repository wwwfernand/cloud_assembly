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
class User < ApplicationRecord
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.login_field = :email
    c.require_password_confirmation = false
    c.log_in_after_create = true
  end

  has_many :articles, inverse_of: :user, dependent: :destroy
  has_many :user_images, inverse_of: :user, dependent: :destroy

  before_validation do
    self.email = email.strip if email.present?
    self.username = username.strip if username.present?
  end

  MIN_USERNAME_LENGTH = 3
  MAX_USERNAME_LENGTH = 100
  MAX_EMAIL_LENGTH = 100
  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 24

  validates :email, :username, :password, presence: true
  validates :email,
            email_format: true,
            allow_blank: true,
            length: { maximum: MAX_EMAIL_LENGTH },
            uniqueness: {
              case_sensitive: false
            },
            if: :will_save_change_to_email?

  validates :username,
            username_format: true,
            allow_blank: true,
            length: { within: MIN_USERNAME_LENGTH..MAX_USERNAME_LENGTH },
            uniqueness: {
              case_sensitive: false
            },
            if: :will_save_change_to_username?

  validates :password,
            password_format: true,
            allow_blank: true,
            length: { within: MIN_PASSWORD_LENGTH..MAX_PASSWORD_LENGTH },
            if: :require_password?
end
