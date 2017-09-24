class IssuePolicy < ApplicationPolicy
  
  def select_issue_response?
    user
  end 
  
end
