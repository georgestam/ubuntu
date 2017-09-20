FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    created_by_id { 1 } # Select the first user

    trait :resolved do
      resolved_at { Faker::Date.between(10.year.ago, Date.today) }
    end

  end

end
