class AlertPolicy < ApplicationPolicy
  
  def edit?
    super_user_or_manager?
  end 
  
  def create?
    super_user_or_manager? || user.field_user?
  end
  
  def new?
    user
  end 
    
end
