FactoryGirl.define do
  
  factory :customer do
    
    id_steama { rand(1000..10000) }
    telephone { rand(100000..10000000) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    account_balance { rand(0..1000) }
    low_balance_warning { rand(0..1000) }
    low_balance_level { rand(0..1000) }
    description { Faker::Lorem.sentence(3) } 
      
  end
  
end

  