class AlertPolicy < ApplicationPolicy
  
  def edit?
    super_user_or_manager?
  end 
  
  def create?
    super_user_or_manager?
  end
  
  def new?
    user
  end 
  
  def create?
    user
  end   
end
