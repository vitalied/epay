FactoryBot.define do
  factory :merchant do
    user
    name { Faker::Company.unique.name }
    description { Faker::Company.catch_phrase }
    email { Faker::Internet.unique.email }
    status { Merchant::STATUS.active }
    total_transaction_sum { Faker::Commerce.price }

    factory :inactive_merchant do
      status { Merchant::STATUS.inactive }
    end
  end
end
