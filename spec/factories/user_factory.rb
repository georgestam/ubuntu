FactoryGirl.define do
  
  factory :user do
    
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { SecureRandom.hex }
    
    trait :manager do 
      role User::ROLES[0] # manager
    end
    
    trait :super_user do 
      role User::ROLES[1] # super
    end
    
    trait :field_user do 
      role User::ROLES[2] # field
    end     
      
  end
  
end