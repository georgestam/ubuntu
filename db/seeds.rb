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

  group_alert_billing = FactoryGirl.create :group_alert, title: "billing", user: manager
  negative_acount = FactoryGirl.create :type_alert, name: "Negative account", group_alert: group_alert_billing
  FactoryGirl.create :issue, type_alert: negative_acount
  
  # Run Steama API
  FactoryGirl.create :type_alert, name: "Usage exceeded twice the normal average", group_alert: group_alert_billing
  
  UpdateDbJob.perform_now
  PullUsageJob.perform_now
  
  main_customer = Customer.first

  2.times do |group_alert|
    group_alert = FactoryGirl.create :group_alert, user: manager 
    2.times do |type_alert|
      type_alert = FactoryGirl.create :type_alert, group_alert: group_alert
      1.times do |issue|
        issue = FactoryGirl.create :issue, type_alert: type_alert
        2.times do
          FactoryGirl.create :alert, issue: issue, type_alert: type_alert, customer: main_customer
        end
        2.times do
          FactoryGirl.create :alert, :resolved, issue: issue, type_alert: type_alert, customer: main_customer
        end
      end
    end
  end
  
  require 'csv'    

  csv_text = File.read('spec/support/top-ups.csv')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    h = row.to_hash
    h["id_steama"] = h["id_steama"].to_i
    h["amount"] = h["amount"].to_i
    h["created_on"] = DateTime.strptime(h["created_on"], '%Y-%m-%d %H:%M:%S%z')
    h["customer_id"] = Customer.find_by(id_steama: h["id_steama"].to_i).id
    Topup.create!(h)
  end
  
end 

if production?
  
  require 'csv'    

  csv_text = File.read('spec/support/top-ups.csv')
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    h = row.to_hash
    h["id_steama"] = h["id_steama"].to_i
    h["amount"] = h["amount"].to_i
    h["created_on"] = DateTime.strptime(h["created_on"], '%Y-%m-%d %H:%M:%S%z')
    h["customer_id"] = Customer.find_by(id_steama: h["id_steama"].to_i).id
    Topup.create!(h)
  end
  
end
