class UsersController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def update_db
    authorize(current_user)
    # pull users database and create new users if they are not in the database
    CreateUsersParser.update_customer_db
    # create alerts if users have negative accounts 
    Alert.users_with_negative_acount
  end 
  
end
