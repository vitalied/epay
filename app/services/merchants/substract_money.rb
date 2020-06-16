module Merchants
  class SubstractMoney < ApplicationService
    attr_reader :merchant, :customer

    def initialize(amount, merchant, customer = nil)
      @amount = amount
      @merchant = merchant
      @customer = customer
    end

    def call
      ActiveRecord::Base.transaction do
        remove_money_from_merchant
        add_money_to_customer
      end
    rescue
      Rails.logger.warn("Can't substract money from merchant! Amount: #{@amount}, Merchant: #{@merchant.name}")
    end

    private

    def remove_money_from_merchant
      original_amount = @merchant.total_transaction_sum
      @merchant.total_transaction_sum -= @amount
      @merchant.save!
    rescue => e
      @merchant.total_transaction_sum = original_amount
      raise e
    end

    def add_money_to_customer
      # original_amount = @customer.amount
      # @customer.amount += @amount
      # @customer.save!
      # rescue => e
      # @customer.amount = original_amount
      # raise e
    end
  end
end
