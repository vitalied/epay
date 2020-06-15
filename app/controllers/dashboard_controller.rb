class DashboardController < BaseController
  def index
    @transactions_count = current_merchant.transactions.count
  end
end
