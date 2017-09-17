FactoryGirl.define do
  
  factory :group_alert do
    
    user
    title { Faker::Lorem.sentence }
      
  end
  
end


   
  