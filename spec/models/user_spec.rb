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
require 'rails_helper'

RSpec.describe User, type: :model do
  include_context 'users_mock_context'

  describe '.valid?' do
    subject { described_class.new(params).valid? }

    let(:params) { user_create_valid_params }

    context 'when valid email, username, password' do
      it { is_expected.to be true }
    end

    context 'when multiple user with valid email, username' do
      before do
        described_class.create(params)
        params.merge!(
          {
            username: Faker::Alphanumeric.alpha(number: described_class::MIN_USERNAME_LENGTH),
            email: Faker::Internet.email
          }
        )
      end

      it { is_expected.to be true }
    end

    [
      'testgmail.com',
      '123',
      '',
      124
    ].each do |email|
      context "when invalid email '#{email}'" do
        before do
          params[:email] = email
        end

        it { is_expected.to be false }
      end
    end

    [
      'aaaa',
      '12345678',
      '23&Tyq7',
      ''
    ].each do |password|
      context "when invalid password '#{password}'" do
        before do
          params[:password] = password
        end

        it { is_expected.to be false }
      end
    end

    [
      Faker::Alphanumeric.alpha(number: described_class::MIN_USERNAME_LENGTH - 1),
      Faker::Alphanumeric.alpha(number: described_class::MAX_USERNAME_LENGTH + 1),
      ''
    ].each do |username|
      context "when invalid username '#{username}'" do
        before do
          params[:username] = username
        end

        it { is_expected.to be false }
      end
    end

    context 'when email taken' do
      before do
        described_class.create(params)
        params[:username] = Faker::Alphanumeric.alpha(number: described_class::MIN_USERNAME_LENGTH)
      end

      it { is_expected.to be false }
    end

    context 'when username taken' do
      before do
        described_class.create(params)
        params[:email] = Faker::Internet.email
      end

      it { is_expected.to be false }
    end
  end
end
