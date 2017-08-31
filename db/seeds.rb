if development? || staging?
  Customer.destroy_all
  User.destroy_all
  Alerts.destroy_all
  TypeAlert.destroy_all
  Query.destroy_all
  GroupAlert.destroy_all

  # Recording.destroy_all

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
  
  ["group_one", "group_two", "group_three"].each do |group|
    group = FactoryGirl.create :group
    type_alert = FactoryGirl.create :type_alert, group_alert: group
    2.times do 
      query = FactoryGirl.create :query, type_alert: type_alert
    end 
    2.times do 
      query = FactoryGirl.create :query, :resolved, type_alert: type_alert, 
    end 
  end 
  
  5.times do 
    FactoryGirl.create :alert
  end 

  # file = File.read('lib/examples/json/example1.json')
  # 
  # 1.times do
  #   Recording.create!({
  #     data: file,
  #     description: Faker::ChuckNorris.fact,
  #     user: User.first,
  #     confidence: 80,
  #     speaker: 1
  #     })
  # end
  # 
  # file = File.read('lib/examples/json/example2.json')
  # 
  # 1.times do
  #   Recording.create!({
  #     data: file,
  #     description: Faker::ChuckNorris.fact,
  #     user: User.first,
  #     confidence: 80,
  #     speaker: 1
  #     })
  # end

end 