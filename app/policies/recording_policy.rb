class RecordingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def show?
    true
  end
  
  def update?
    record.user == user
  end
  
  def create?
    record.user == user
  end
  
  def destroy?
    true
  end 
  
end
