module Admin
  class MerchantDestroyer < ApplicationService
    attr_reader :merchant

    def initialize(merchant)
      @merchant = merchant
    end

    def call
      return false unless @merchant.can_be_deleted?

      ActiveRecord::Base.transaction do
        @user = @merchant.user

        @user.destroy
      end

      true
    rescue => e
      @merchant.errors[:base] << e.message

      false
    end
  end
end
