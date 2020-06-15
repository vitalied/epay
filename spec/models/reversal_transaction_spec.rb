require 'rails_helper'

RSpec.describe ReversalTransaction, type: :model do
  let(:authorize_transaction) { create :authorize_transaction }
  let(:reversal_transaction) { create :reversal_transaction, authorize_transaction: authorize_transaction }

  it { is_expected.to belong_to(:authorize_transaction).optional }

  it { is_expected.to validate_presence_of(:reference_uuid) }

  context '#check_reference_transaction' do
    it 'should have approved status' do
      expect(reversal_transaction.approved?).to be_truthy
    end

    context 'when authorize_transaction have status error' do
      before { authorize_transaction.status_error! }

      it 'should set status to error' do
        expect(reversal_transaction.error?).to be_truthy
      end
    end
  end

  context '#reverse_authorize_transaction' do
    it 'it should reverse authorize transaction' do
      expect(authorize_transaction.reversed?).to be_falsey
      expect(reversal_transaction.authorize_transaction.reversed?).to be_truthy
    end
  end
end
