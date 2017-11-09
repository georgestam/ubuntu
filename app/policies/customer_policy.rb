class CustomerPolicy < ApplicationPolicy
  
  def edit?
    user.manager?
  end 
  
  def create?
    false
  end
   
end
