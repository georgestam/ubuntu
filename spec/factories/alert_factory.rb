FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    created_by { Faker::Name.first_name }
    assigned_to { Faker::Name.first_name }
    # closed_at { rand(10.years).ago }
    # resolved_at { rand(10.years).ago }

    trait :resolved do
      resolved_at { Time.current }
    end

  end

end



