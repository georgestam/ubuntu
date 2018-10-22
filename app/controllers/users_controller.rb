class UsersController < ApplicationController
  def index
    policy_scope(User)
    if current_user.field_user?
      redirect_to new_alert_path
    end
  end

  def update_db

    authorize(current_user)
    # pull users database and create new users if they are not in the database
    Customer.update_customer_db
    # create alerts if users have negative accounts
    # Alert.check_customers_with_negative_acount

    flash[:notice] = "database updated successfully!"
    redirect_to root_path
  end

  def complate_last_10
    authorize(current_user)
    if current_user.field_user?
      redirect_to new_alert_path
    end

    alerts = Alert.all_open.order('id desc').offset(10)
    alerts.each do |alert|
      alert.resolved!
    end
    flash[:notice] = "all alerts has been completed except the last 10"
    redirect_to root_path
  end

end
