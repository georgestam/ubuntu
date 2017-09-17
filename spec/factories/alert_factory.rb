FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    created_by_id { 1 } # Select the first user

    trait :resolved do
      resolved_at { rand(1.year).ago }
    end

  end

end



