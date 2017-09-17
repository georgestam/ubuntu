FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    user
    created_by { user }

    trait :resolved do
      resolved_at { rand(1.years).ago }
    end

  end

end



