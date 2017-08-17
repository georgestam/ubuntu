FactoryGirl.define do
  
  factory :recording do
    
    user
    data { "some json parsed to a string" }
    description { Faker::ChuckNorris.fact }
      
  end
  
end