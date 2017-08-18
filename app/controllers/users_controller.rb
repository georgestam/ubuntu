class UsersController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def update_db
    authorize(current_user)
    CreateUsersParser.update_users_db 
  end 
  
end
