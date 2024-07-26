# frozen_string_literal: true

class UserImagePolicy
  class Scope
    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, 'must be logged in' unless user

      @user = user
      @scope = scope
    end

    def resolve
      scope.owned(@user.id)
    end

    private

    attr_reader :user, :scope
  end
end
