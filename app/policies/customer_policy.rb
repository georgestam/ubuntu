class CustomerPolicy < ApplicationPolicy
  
  def edit?
    false
  end 
  
  def create?
    false
  end
   
end
