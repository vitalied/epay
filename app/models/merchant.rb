# == Schema Information
#
# Table name: merchants
#
#  id                    :bigint           not null, primary key
#  user_id               :bigint           not null
#  name                  :string(255)      not null
#  description           :text(65535)
#  email                 :string(255)      not null
#  status                :string(10)       not null
#  total_transaction_sum :decimal(12, 2)   default(0.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_merchants_on_email    (email) UNIQUE
#  index_merchants_on_name     (name) UNIQUE
#  index_merchants_on_status   (status)
#  index_merchants_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Merchant < ApplicationRecord
  include DowncaseEmailAttributes

  belongs_to :user
  has_many :transactions

  auto_strip_attributes :name, :description, :email, :status

  STATUSES = %w[active inactive].freeze
  STATUS = Struct.new(*STATUSES.map(&:to_sym)).new(*STATUSES)

  include StatusScopesAndMethods

  validates :user_id, :name, :email, :status, :total_transaction_sum, presence: true
  validates :name, :email, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :email, 'valid_email_2/email': true
  validates :status, inclusion: STATUSES
  validates :total_transaction_sum, numericality: { greater_than_or_equal_to: 0.0 }

  def can_be_deleted?
    transactions.none?
  end
end
