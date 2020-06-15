require 'rails_helper'

RSpec.describe RefundTransaction, type: :model do
  let(:total_transaction_sum) { 999_999.99 }
  let(:amount) { 10.00 }
  let(:merchant) { create :merchant, total_transaction_sum: total_transaction_sum }
  let(:charge_transaction) { create :charge_transaction, merchant: merchant, amount: amount * 2 }
  let(:refund_transaction) do
    create :refund_transaction, merchant: merchant, charge_transaction: charge_transaction, amount: amount
  end

  it { is_expected.to belong_to(:charge_transaction).optional }

  it { is_expected.to validate_presence_of(:reference_uuid) }

  context '#check_reference_transaction' do
    it 'should have approved status' do
      expect(refund_transaction.approved?).to be_truthy
    end

    context 'when charge_transaction have status error' do
      before { charge_transaction.status_error! }

      it 'should set status to error' do
        expect(refund_transaction.error?).to be_truthy
      end
    end
  end

  context '#refund_charge_transaction' do
    it 'it should refund charge transaction' do
      expect(charge_transaction.refunded?).to be_falsey
      expect(refund_transaction.charge_transaction.refunded?).to be_truthy
    end
  end

  context '#substract_money_from_merchant' do
    context 'when status is approved' do
      it 'should substract money from merchant' do
        expect(refund_transaction.approved?).to be_truthy
        expect(merchant.total_transaction_sum).not_to eql(total_transaction_sum)
        expect(merchant.total_transaction_sum).to eql(
          total_transaction_sum + charge_transaction.amount - refund_transaction.amount
        )
      end
    end

    context 'when status is error' do
      let(:refund_transaction) do
        create :refund_transaction, merchant: merchant, charge_transaction: charge_transaction,
                                    status: Transaction::STATUS.error
      end

      it 'should add money to merchant' do
        expect(merchant.total_transaction_sum).to eql(total_transaction_sum)
      end
    end
  end
end
