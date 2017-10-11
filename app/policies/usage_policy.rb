class UsagePolicy < ApplicationPolicy
  
  def new? 
    false
  end 
  
  def edit? 
    false
  end 
  
  def show? 
    false
  end 
  
  def destroy?
    false
  end 
    
end
