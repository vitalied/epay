module Admin
  class MerchantCreator < ApplicationService
    attr_reader :merchant

    def initialize(merchant_params)
      @merchant_params = merchant_params
    end

    def call
      @merchant = Merchant.new(@merchant_params)

      ActiveRecord::Base.transaction do
        @user = User.create!(email: @merchant.email, password: Devise.friendly_token)
        @merchant.user = @user
        @merchant.save!

        @success = @merchant.errors.blank? && @user.errors.blank?

        raise ActiveRecord::Rollback unless @success
      end

      @success
    rescue => e
      @merchant.errors[:base] << e.message

      false
    end
  end
end
