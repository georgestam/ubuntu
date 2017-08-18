class UsersController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def update_db
    authorize(current_user)
    if CreateUsersParser.update_users_db 
    else
      #to do alert. 
    end 
    redirect_to users_path
  end 
  
end
