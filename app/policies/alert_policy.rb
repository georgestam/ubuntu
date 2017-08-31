class AlertPolicy < ApplicationPolicy
  
  def new?
    user
  end 
  
  def create?
    user
  end   
  
  def select_issue_response?
    user
  end 
end
