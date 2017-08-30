FactoryGirl.define do
  
  factory :user do
    
    email { Faker::Internet.email }
    password { SecureRandom.hex }
    
    trait :admin do 
      admin true
    end 
      
  end
  
end