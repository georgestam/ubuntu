class UsersController < ApplicationController
  def index
    policy_scope(User)
  end
  
  def update_db
    
    authorize(current_user)
    # pull users database and create new users if they are not in the database
    CreateUsersParser.update_customer_db
    # create alerts if users have negative accounts 
    Alert.check_customers_with_negative_acount
    
    flash[:notice] = "database updated successfully!"
    redirect_to users_path
  end 
  
end
