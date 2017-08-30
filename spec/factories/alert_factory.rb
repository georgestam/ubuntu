FactoryGirl.define do
  
  factory :alert do
    
    customer
    type_alert
    status
    description { Faker::ChuckNorris.fact }
    created_by { Faker::Name.first_name }
    assigned_to { Faker::Name.first_name }
    resolved_comments { Faker::Lorem.sentence(3) }
    # closed_at { rand(10.years).ago }
    # resolved_at { rand(10.years).ago }
      
  end
  
end


   
  