# frozen_string_literal: true

shared_context 'users_mock_context' do
  let(:user_create_valid_params) do
    {
      username: Faker::Alphanumeric.alpha(number: 4),
      email: Faker::Internet.email,
      password: 'hY5l%V2x'
    }
  end
end
