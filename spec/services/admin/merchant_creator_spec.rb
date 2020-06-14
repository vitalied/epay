require 'rails_helper'

describe Admin::MerchantCreator do
  let(:merchant_params) { build_attributes(build(:merchant), :name, :description, :email, :status) }
  let(:merchant_creator) { Admin::MerchantCreator.new(merchant_params) }

  it 'should create merchant' do
    expect do
      expect(merchant_creator.call).to be_truthy
    end.to change(User, :count).by(1)
                               .and change(Merchant, :count).by(1)
  end

  context 'when merchant with the same details already exists' do
    before { merchant_creator.call }

    it 'should create merchant' do
      expect do
        expect(merchant_creator.call).to be_falsey
      end.to not_change(User, :count)
        .and not_change(Merchant, :count)
    end
  end
end
