FactoryGirl.define do
  
  factory :customer do
    
    id_steama { rand(1000..10_000_000) }
    telephone { rand(100_000..10_000_000) }
    first_name { Faker::LordOfTheRings.character }
    last_name { Faker::Superhero.name }
    account_balance { rand(0..1000) }
    low_balance_warning { rand(0..1000) }
    low_balance_level { rand(0..1000) }
    description { Faker::HowIMetYourMother.catch_phrase } 
      
  end
  
end

  