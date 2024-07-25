# frozen_string_literal: true

# session record for logged user
class UserSession < Authlogic::Session::Base
  disable_magic_states true
end
