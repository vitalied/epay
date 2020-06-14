module Admin
  class MerchantsController < ApplicationController
    before_action :set_merchant, only: %i[show edit update destroy]

    # GET /admin/merchants
    def index
      @merchants = Merchant.order(created_at: :desc)
    end

    # GET /admin/merchants/1
    def show
      @transactions = @merchant.transactions.order(created_at: :desc)
    end

    # GET /admin/merchants/new
    def new
      @merchant = Merchant.new
    end

    # GET /admin/merchants/1/edit
    def edit; end

    # POST /admin/merchants
    def create
      merchant_creator = Admin::MerchantCreator.new(merchant_params)

      if merchant_creator.call
        redirect_to admin_merchants_path, notice: 'Merchant was successfully created.'
      else
        @merchant = merchant_creator.merchant

        render :new
      end
    end

    # PATCH/PUT /admin/merchants/1
    def update
      if @merchant.update(merchant_params)
        redirect_to admin_merchants_path, notice: 'Merchant was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/merchants/1
    def destroy
      alert = if Admin::MerchantDestroyer.call(@merchant)
                { notice: 'Merchant was successfully deleted.' }
              else
                { alert: "Merchant can't be deleted. There are related Transactions." }
              end

      redirect_to admin_merchants_path, alert
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def merchant_params
      params.fetch(:merchant, {}).permit(:name, :description, :email, :status)
    end
  end
end
