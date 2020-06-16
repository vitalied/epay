require 'rails_helper'

describe Merchants::SubstractMoney do
  let!(:merchant) { create :merchant, total_transaction_sum: 9.99 }

  it 'should substract money' do
    Merchants::SubstractMoney.call(9.99, merchant)
    expect(merchant.total_transaction_sum).to eql(0.0)
  end

  context "when money in merchant's account are less then substracted amount" do
    it "shouldn't substract money" do
      Merchants::SubstractMoney.call(10.0, merchant)
      expect(merchant.total_transaction_sum).to eql(9.99)
    end
  end
end
