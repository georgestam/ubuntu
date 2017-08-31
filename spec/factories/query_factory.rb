FactoryGirl.define do
  
  factory :issue do
    
    type_alert
    resolution { Faker::ChuckNorris.fact }
      
  end
  
end


   
  