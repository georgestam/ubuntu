if development? || staging?
  Customer.destroy_all
  Alert.destroy_all
  Issue.destroy_all
  TypeAlert.destroy_all
  GroupAlert.destroy_all
  User.destroy_all

  password = "password10"

  manager = FactoryGirl.create :user, :manager, email: "jordi@ubuntu.org", password: password, name: "jordi", slack_username: "@jordi"
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

  negative_acount = FactoryGirl.create :type_alert, name: "Negative account", user: manager
  FactoryGirl.create :issue, type_alert: negative_acount

end

if production?
  Alert.all.each do |alert|
    alert.user = User.find(7)
    alert.save!
  end
end
