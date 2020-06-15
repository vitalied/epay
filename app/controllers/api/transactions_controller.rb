module Api
  class TransactionsController < BaseController
    protect_from_forgery with: :null_session

    # POST /api/transactions
    # Headers:
    # Accept application/json
    # Content-Type application/json
    # Authorization Token 123456
    def create
      @transaction = Transaction.new(transaction_params)
      @transaction.save!

      render json: @transaction, status: :created
    rescue
      render_errors(@transaction.errors)
    end

    private

    def perform_authorization
      authorize :merchant_token, :can?
    end

    def transaction_params
      res = params.permit(:type, :reference_uuid, :uuid, :amount, :status, :customer_email, :customer_phone)
      if res[:type].present?
        res[:type].capitalize!
        res[:type] = if res[:type].match(/transaction$/i)
                       res[:type].gsub(/transaction$/, 'Transaction')
                     else
                       res[:type] = "#{res[:type]}Transaction"
                     end
      end
      res.merge(merchant: current_merchant)
    end
  end
end
