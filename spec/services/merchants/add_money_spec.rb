require 'rails_helper'

describe Merchants::AddMoney do
  let!(:merchant) { create :merchant, total_transaction_sum: 0.0 }

  it 'should add money' do
    Merchants::AddMoney.call(10.0, merchant)
    expect(merchant.total_transaction_sum).to eql(10.0)

    Merchants::AddMoney.call(19.99, merchant)
    expect(merchant.total_transaction_sum).to eql(29.99)
  end

  context 'when there are merchant save errors' do
    before { expect_any_instance_of(Merchant).to receive(:save!).and_raise('error') }

    it "shouldn't add money" do
      Merchants::AddMoney.call(10.0, merchant)
      expect(merchant.total_transaction_sum).to eql(0.0)
    end
  end
end
