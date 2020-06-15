class DeleteOldTransactionsJob < ApplicationJob
  def perform
    Transaction.where(created_at: ..1.hour.ago).find_each do |transaction|
      next if transaction.referencing_transaction.present?

      transaction.destroy
    end
  end
end
