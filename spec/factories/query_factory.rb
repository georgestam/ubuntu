FactoryGirl.define do
  
  factory :query do
    
    type_alert
    resolution { Faker::ChuckNorris.fact }
      
  end
  
end


   
  