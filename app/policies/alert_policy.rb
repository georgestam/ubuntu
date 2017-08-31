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
  
  def select_alert_subgroup?
    user
  end 
  
  def select_query?
    user
  end 
  
end
