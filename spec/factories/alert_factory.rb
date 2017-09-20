FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    created_by_id { 1 } # Select the first user

    trait :resolved do
      resolved_at { Faker::Date.between(10.years.ago, DateTime.current) }
    end

  end

end
