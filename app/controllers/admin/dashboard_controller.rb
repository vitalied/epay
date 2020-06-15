module Admin
  class DashboardController < Admin::BaseController
    def index
      @merchants_count = 0
      @transactions_count = 0
    end
  end
end
