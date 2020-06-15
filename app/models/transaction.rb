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
class Transaction < ApplicationRecord
  include DowncaseEmailAttributes

  belongs_to :merchant
  belongs_to :reference_transaction, class_name: :Transaction,
                                     primary_key: :uuid, foreign_key: :reference_uuid, optional: true
  has_one :referencing_transaction, class_name: :Transaction, primary_key: :uuid, foreign_key: :reference_uuid

  auto_strip_attributes :type, :uuid, :status, :customer_email, :customer_phone

  TYPES = %w[AuthorizeTransaction ChargeTransaction RefundTransaction ReversalTransaction].freeze
  TYPE = Struct.new(*TYPES.map(&:underscore).map(&:to_sym)).new(*TYPES)

  STATUSES = %w[approved reversed refunded error].freeze
  STATUS = Struct.new(*STATUSES.map(&:to_sym)).new(*STATUSES)

  include StatusScopesAndMethods

  before_validation :check_reference_transaction

  validates :type, :merchant_id, :uuid, :status, :customer_email, presence: true
  validates :type, inclusion: TYPES
  validates :reference_uuid, :uuid, length: { maximum: 50 }
  validates :uuid, uniqueness: { case_sensitive: false }
  validates :amount, numericality: { greater_than: 0.0 }, presence: true,
                     unless: proc { |t| t.type == TYPE.reversal_transaction }
  validates :status, inclusion: STATUSES
  validates :customer_email, :customer_phone, length: { maximum: 255 }
  validates :customer_email, 'valid_email_2/email': true

  private

  # Only approved or refunded transactions can be referenced,
  # otherwise the submitted transaction will be created with status error
  def check_reference_transaction
    return if reference_transaction.blank?
    return if reference_transaction&.status&.in?([STATUS.approved, STATUS.refunded])

    self.reference_transaction = nil
    self.status = STATUS.error
  end
end
