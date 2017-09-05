FactoryGirl.define do
  
  factory :user do
    
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { SecureRandom.hex }
    
    trait :admin do 
      admin true
    end
    
    trait :manager do 
      role User::ROLES[0] #manager
    end
    
    trait :field do 
      role User::ROLES[1] #super
    end
    
    trait :super do 
      role User::ROLES[2] #field
    end     
      
  end
  
end