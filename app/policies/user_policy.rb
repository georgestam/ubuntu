class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user.manager?
  end

  def main?
    record == user
  end

  def update_db?
    record == user
  end

  def complate_last_10?
    record == user
  end
end
