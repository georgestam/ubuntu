if development? || staging?
  Customer.destroy_all
  User.destroy_all
  Alert.destroy_all
  Query.destroy_all
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
      2.times do |query|
        query = FactoryGirl.create :query, type_alert: type_alert
        2.times do 
          FactoryGirl.create :alert, query: query 
        end 
        2.times do 
          FactoryGirl.create :alert, :resolved, query: query 
        end 
      end 
    end 
  end 
  
  FactoryGirl.create :group_alert, title: "new"

end 