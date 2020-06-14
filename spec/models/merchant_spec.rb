require 'rails_helper'

RSpec.describe Merchant, type: :model do
  let!(:merchant) { create :merchant }

  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it_behaves_like :validate_email, :email
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Merchant::STATUSES) }
  it { is_expected.to validate_numericality_of(:total_transaction_sum).is_greater_than_or_equal_to(0.0) }

  %i[id user_id name description email status total_transaction_sum].each do |attr|
    it { is_expected.to respond_to(attr) }
  end

  context 'scoping' do
    let!(:inactive_merchant) { create :inactive_merchant }

    context 'by active' do
      it 'filters by active status' do
        expect(Merchant.active).to match_array(merchant)
      end
    end

    context 'by inactive' do
      it 'filters by inactive status' do
        expect(Merchant.inactive).to match_array(inactive_merchant)
      end
    end
  end

  context 'before validation' do
    let(:email) { 'Info@example.Org' }
    let(:merchant) { build :merchant, email: email }

    it 'should downcase the email' do
      merchant.valid?

      expect(merchant.email).to eql(email.downcase)
    end
  end

  context '#can_be_deleted?' do
    it 'should be true' do
      expect(merchant.can_be_deleted?).to be_truthy
    end
  end
end
