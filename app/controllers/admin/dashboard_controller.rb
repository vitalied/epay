module Admin
  class DashboardController < Admin::BaseController
    def index
      @merchants_count = Merchant.count
      @transactions_count = Transaction.count
    end
  end
end
