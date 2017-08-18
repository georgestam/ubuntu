class UsersController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def update_db
    authorize(current_user)
    CreateUsersParser.update_customer_db 
    CreateAlerts.update_alerts
  end 
  
end
