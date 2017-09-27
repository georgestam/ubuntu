FactoryGirl.define do

  factory :alert do

    customer
    type_alert
    user
    created_by_id { User.first } # TODO: Assign another user in this field (alerts belongs_to 2 users)

    trait :resolved do
      resolved_at { Faker::Date.forward(23) }
    end

  end

end
