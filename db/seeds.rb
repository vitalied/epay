# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'admin@dev.local', password: '123456', admin: true)

Admin::MerchantCreator.call(name: 'Merchant 1', email: 'merchant1@dev.local', status: Merchant::STATUS.active)
Admin::MerchantCreator.call(name: 'Merchant 2', email: 'merchant2@dev.local', status: Merchant::STATUS.inactive)

user = Merchant.first.user
user.password = '123456'
user.authentication_token = '123456'
user.save!
user = Merchant.last.user
user.password = '654321'
user.authentication_token = '654321'
user.save!

Transaction::STATUSES.each do |status|
  AuthorizeTransaction.create!(
    merchant: Merchant.first,
    uuid: SecureRandom.uuid,
    amount: 29.99,
    status: Transaction::STATUS.send(status),
    customer_email: 'customer1@dev.local',
    customer_phone: '+5551111111'
  )
end

authorize_transaction = AuthorizeTransaction.create!(
  merchant: Merchant.first,
  uuid: SecureRandom.uuid,
  amount: 9.99,
  status: Transaction::STATUS.approved,
  customer_email: 'customer2@dev.local',
  customer_phone: '+5552222222'
)

charge_transaction = ChargeTransaction.create!(
  merchant: Merchant.first,
  authorize_transaction: authorize_transaction,
  uuid: SecureRandom.uuid,
  amount: 9.99,
  status: Transaction::STATUS.approved,
  customer_email: 'customer2@dev.local',
  customer_phone: '+5552222222'
)

refund_transaction = RefundTransaction.create!(
  merchant: Merchant.first,
  charge_transaction: charge_transaction,
  uuid: SecureRandom.uuid,
  amount: 9.99,
  status: Transaction::STATUS.approved,
  customer_email: 'customer2@dev.local',
  customer_phone: '+5552222222'
)

authorize_transaction = AuthorizeTransaction.create!(
  merchant: Merchant.first,
  uuid: SecureRandom.uuid,
  amount: 19.99,
  status: Transaction::STATUS.approved,
  customer_email: 'customer3@dev.local',
  customer_phone: '+5553333333'
)

reversal_transaction = ReversalTransaction.create!(
  merchant: Merchant.first,
  authorize_transaction: authorize_transaction,
  uuid: SecureRandom.uuid,
  status: Transaction::STATUS.approved,
  customer_email: 'customer3@dev.local',
  customer_phone: '+5553333333'
)
