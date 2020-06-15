require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:transaction) { create :authorize_transaction }

  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to belong_to(:reference_transaction).optional }
  it { is_expected.to have_one(:referencing_transaction) }

  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_inclusion_of(:type).in_array(Transaction::TYPES) }
  it { is_expected.to validate_presence_of(:merchant_id) }
  it { is_expected.to validate_length_of(:reference_uuid).is_at_most(50) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_uniqueness_of(:uuid).case_insensitive }
  it { is_expected.to validate_length_of(:uuid).is_at_most(50) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0.0) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Transaction::STATUSES) }
  it { is_expected.to validate_presence_of(:customer_email) }
  it { is_expected.to validate_length_of(:customer_email).is_at_most(255) }
  it_behaves_like :validate_email, :customer_email

  %i[id type merchant_id reference_uuid uuid amount status customer_email customer_phone].each do |attr|
    it { is_expected.to respond_to(attr) }
  end

  context 'scoping' do
    let!(:error_transaction) { create :authorize_transaction, status: Transaction::STATUS.error }

    context 'by approved' do
      it 'filters by approved status' do
        expect(Transaction.approved).to match_array(transaction)
      end
    end

    context 'by error' do
      it 'filters by error status' do
        expect(Transaction.error).to match_array(error_transaction)
      end
    end
  end

  context 'before validation' do
    let(:customer_email) { 'Info@example.Org' }
    let(:transaction) { build :authorize_transaction, customer_email: customer_email }

    it 'should downcase the customer_email' do
      transaction.valid?

      expect(transaction.customer_email).to eql(customer_email.downcase)
    end
  end
end
