if development? || staging?
  Customer.destroy_all
  User.destroy_all
  Alert.destroy_all
  Issue.destroy_all
  TypeAlert.destroy_all
  GroupAlert.destroy_all

  User.create!({
    email: "admin@ubuntu.org",
    password: "password10",
    admin: true
    })

  User.create!({
    email: "field@ubuntu.org",
    password: "password10",
    admin: false
    })
    
  User.create!({
    email: "super@ubuntu.org",
    password: "password10",
    admin: false
    })
  
  3.times do |group_alert|
    group_alert = FactoryGirl.create :group_alert
    3.times do |type_alert|
      type_alert = FactoryGirl.create :type_alert, group_alert: group_alert
      2.times do |issue|
        issue = FactoryGirl.create :issue, type_alert: type_alert
        2.times do 
          FactoryGirl.create :alert, issue: issue 
        end 
        2.times do 
          FactoryGirl.create :alert, :resolved, issue: issue 
        end 
      end 
    end 
  end 
  
  FactoryGirl.create :group_alert, title: "new"
  negative_acount = FactoryGirl.create :type_alert, name: "Customer has negative account"
  FactoryGirl.create :issue, type_alert: negative_acount 

end 

if production?
  FactoryGirl.create :group_alert, title: "new"
  negative_acount = FactoryGirl.create :type_alert, name: "Customer has negative account"
  FactoryGirl.create :issue, type_alert: negative_acount 
end 