FactoryGirl.define do
  
  factory :type_alert do
    
    group_alert
    name { Faker::Lorem.sentence }
      
  end
  
end


   
  