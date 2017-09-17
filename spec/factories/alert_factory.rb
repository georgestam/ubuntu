FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user

    trait :resolved do
      resolved_at { rand(1.year).ago }
    end

  end

end



