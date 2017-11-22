FactoryGirl.define do
  
  factory :balance do
    
    customer
    value_cents { rand(0..10_000) }
    created_on { Date.today }
      
  end
  
  trait :four_days_ago do 
    created_on { Faker::Date.between(4.days.ago, 4.days.ago) }
    
  end
  
  trait :negative_acount do 
    value_cents { -100 }
  end
  
end


   
  