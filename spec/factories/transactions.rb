FactoryBot.define do
  factory :authorize_transaction do
    merchant
    uuid { SecureRandom.uuid }
    amount { Faker::Commerce.price }
    status { Transaction::STATUS.approved }
    customer_email { Faker::Internet.unique.email }
    customer_phone { Faker::PhoneNumber.unique.cell_phone_in_e164 }
  end

  factory :charge_transaction do
    merchant
    authorize_transaction
    uuid { SecureRandom.uuid }
    amount { authorize_transaction.amount }
    status { Transaction::STATUS.approved }
    customer_email { authorize_transaction.customer_email }
    customer_phone { authorize_transaction.customer_phone }
  end

  factory :refund_transaction do
    merchant
    charge_transaction
    uuid { SecureRandom.uuid }
    amount { charge_transaction.amount }
    status { Transaction::STATUS.approved }
    customer_email { charge_transaction.customer_email }
    customer_phone { charge_transaction.customer_phone }
  end

  factory :reversal_transaction do
    merchant
    authorize_transaction
    uuid { SecureRandom.uuid }
    amount { authorize_transaction.amount }
    status { Transaction::STATUS.approved }
    customer_email { authorize_transaction.customer_email }
    customer_phone { authorize_transaction.customer_phone }
  end
end
