FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    created_by { user }
    # closed_at { rand(10.years).ago }
    # resolved_at { rand(10.years).ago }

    trait :resolved do
      resolved_at { Time.current }
    end

  end

end



