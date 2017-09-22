class AlertPolicy < ApplicationPolicy
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end 
  
  def edit?
    super_user_or_manager?
  end 
  
  def create?
    user
  end
  
  def update?
    user
  end
  
  def new?
    user
  end   
  
  def select_issue_response?
    user
  end 
  
  def select_alert_subgroup?
    user
  end 
  
  def select_issue?
    user
  end 
  
end
