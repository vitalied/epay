class TransactionsController < BaseController
  # GET /transactions
  def index
    @transactions = current_merchant.transactions.order(created_at: :desc)
  end
end
