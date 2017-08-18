class UsersController < ApplicationController
  def index
    policy_scope(User)
    
    data_test = CreateUsersParser.update_users_db  
  end
  
  def show
    @user = User.find(params[:id])
    authorize @user
    @recordings = Recording.where(user: @user)
  end
end
