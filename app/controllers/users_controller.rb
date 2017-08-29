class UsersController < ApplicationController
  def index
    policy_scope(User)
    unless current_user.admin
      redirect_to new_alert_path
    end 
  end
  
  def update_db
    
    authorize(current_user)
    # pull users database and create new users if they are not in the database
    CreateUsersParser.update_customer_db
    # create alerts if users have negative accounts 
    Alert.check_customers_with_negative_acount
    
    flash[:notice] = "database updated successfully!"
    redirect_to root_path
  end 
  
end
