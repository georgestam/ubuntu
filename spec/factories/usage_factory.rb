FactoryGirl.define do
  
  factory :usage do
    
    meter
    api_data { "Api Data" }
    created_on { Faker::Date.forward(23) }
      
  end
  
end