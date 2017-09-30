if development? || staging?
  Customer.destroy_all
  Alert.destroy_all
  Issue.destroy_all
  TypeAlert.destroy_all
  GroupAlert.destroy_all
  User.destroy_all
  Meter.destroy_all
  Usage.destroy_all

  password = "password10"

  manager = FactoryGirl.create :user, :manager, email: "jordi@ubuntu.org", password: password, name: "jordi", slack_username: "@jordi"
  FactoryGirl.create :user, :manager, email: "ubuntu@ubuntu.org", password: password, name: "Ubuntu", slack_username: "@ubuntu"
  FactoryGirl.create :user, :super_user, name: 'test_super_user', email: "super@ubuntu.org", password: password
  FactoryGirl.create :user, :field_user, name: 'test_field_user', email: "field@ubuntu.org", password: password

  2.times do |group_alert|
    group_alert = FactoryGirl.create :group_alert, user: manager 
    2.times do |type_alert|
      type_alert = FactoryGirl.create :type_alert, group_alert: group_alert
      1.times do |issue|
        issue = FactoryGirl.create :issue, type_alert: type_alert
        2.times do
          FactoryGirl.create :alert, issue: issue, type_alert: type_alert
        end
        2.times do
          FactoryGirl.create :alert, :resolved, issue: issue, type_alert: type_alert
        end
      end
    end
  end

  group_alert = FactoryGirl.create :group_alert, title: "billing", user: manager
  negative_acount = FactoryGirl.create :type_alert, name: "Negative account", group_alert: group_alert
  FactoryGirl.create :issue, type_alert: negative_acount
  
  # Run Steama API
  Customer.destroy_all
  UpdateDbJob.perform_now
  PullUsageJob.perform_now
  
end 

if production?
  
  date = Date.parse('2017-09-01') 
  
  loop do 
    Customer.all.each do |customer| 
      unless customer.meters.any?
        customer.meters.create!(customer: customer)
      end 
      Usage.request_usage_to_api(date, customer.meters.first.id) 
    end 
    
  date = date + 1
  break if Date.current == date
  end 
  
end
