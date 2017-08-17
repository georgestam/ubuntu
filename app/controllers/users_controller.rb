class UsersController < ApplicationController
  def index
    @users = policy_scope(User)
  end
  
  def show
    @user = User.find(params[:id])
    authorize @user
    @recordings = Recording.where(user: @user)
  end
end
