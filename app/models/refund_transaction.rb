# == Schema Information
#
# Table name: transactions
#
#  id             :bigint           not null, primary key
#  type           :string(20)       not null
#  merchant_id    :bigint           not null
#  reference_uuid :string(50)
#  uuid           :string(50)       not null
#  amount         :decimal(12, 2)
#  status         :string(20)       not null
#  customer_email :string(255)      not null
#  customer_phone :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_transactions_on_merchant_id     (merchant_id)
#  index_transactions_on_reference_uuid  (reference_uuid)
#  index_transactions_on_status          (status)
#  index_transactions_on_type            (type)
#  index_transactions_on_uuid            (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...                          (merchant_id => merchants.id)
#  index_transactions_on_reference_uuid  (reference_uuid => transactions.uuid)
#
class RefundTransaction < Transaction
  belongs_to :charge_transaction, class_name: :ChargeTransaction,
                                  primary_key: :uuid, foreign_key: :reference_uuid, optional: true

  delegate :authorize_transaction, to: :charge_transaction

  validates :reference_uuid, presence: true, unless: :error?

  after_save :refund_charge_transaction
  after_save :substract_money_from_merchant, if: :approved?

  def refund_charge_transaction
    charge_transaction&.status_refunded!
  end

  private

  def substract_money_from_merchant
    Merchants::SubstractMoney.call(amount, merchant)
  end
end
