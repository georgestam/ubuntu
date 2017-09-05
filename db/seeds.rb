Customer.destroy_all
User.destroy_all
TypeAlert.destroy_all

# Recording.destroy_all

password = "password10"

FactoryGirl.create :user, :manager, email: "admin@ubuntu.org", password: password 
FactoryGirl.create :user, :super_user, name: 'test_super_user', email: "super@ubuntu.org", password: password
FactoryGirl.create :user, :field_user, name: 'test_field_user', email: "field@ubuntu.org", password: password

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

TypeAlert.create!({
  name: "negative_account"
  })
  
Status.create!({
  name: "open"
  })
Status.create!({
  name: "closed"
  })
Status.create!({
  name: "Resolved"
  })
  
if production? 

  FactoryGirl.create :user, :super_user, name: 'test_super_user', email: "super@ubuntu.org", password: password
  FactoryGirl.create :user, :field_user, name: 'test_field_user', email: "field@ubuntu.org", password: password
  
end 