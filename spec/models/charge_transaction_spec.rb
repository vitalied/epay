require 'rails_helper'

RSpec.describe ChargeTransaction, type: :model do
  let(:merchant) { create :merchant, total_transaction_sum: 0.0 }
  let(:authorize_transaction) { create :authorize_transaction, merchant: merchant }
  let(:charge_transaction) do
    create :charge_transaction, merchant: merchant, authorize_transaction: authorize_transaction
  end

  it { is_expected.to belong_to(:authorize_transaction).optional }
  it { is_expected.to have_one(:refund_transaction) }

  it { is_expected.to validate_presence_of(:reference_uuid) }

  context '#check_reference_transaction' do
    it 'should have approved status' do
      expect(charge_transaction.approved?).to be_truthy
    end

    context 'when authorize_transaction have status error' do
      before { authorize_transaction.status_error! }

      it 'should set status to error' do
        expect(charge_transaction.error?).to be_truthy
      end
    end
  end

  context '#add_money_to_merchant' do
    context 'when status is approved' do
      it 'should add money to merchant' do
        expect(charge_transaction.approved?).to be_truthy
        expect(merchant.total_transaction_sum).to eql(charge_transaction.amount)
      end
    end

    context 'when status is error' do
      let(:charge_transaction) do
        create :charge_transaction, merchant: merchant, authorize_transaction: authorize_transaction,
                                    status: Transaction::STATUS.error
      end

      it 'should add money to merchant' do
        expect(merchant.total_transaction_sum).to eql(0.0)
      end
    end
  end
end
