require 'rails_helper'

describe Admin::MerchantDestroyer do
  let!(:merchant) { create :merchant }
  let(:merchant_destroyer) { Admin::MerchantDestroyer.new(merchant) }

  it 'should delete merchant' do
    expect do
      expect(merchant_destroyer.call).to be_truthy
    end.to change(User, :count).by(-1)
                               .and change(Merchant, :count).by(-1)
  end

  context "when merchant can't be deleted" do
    before { expect_any_instance_of(Merchant).to receive(:can_be_deleted?).and_return(false) }

    it "shouldn't delete merchant" do
      expect do
        expect(merchant_destroyer.call).to be_falsey
      end.to not_change(User, :count)
        .and not_change(Merchant, :count)
    end
  end

  context "when user can't be deleted" do
    before { expect_any_instance_of(User).to receive(:destroy).and_raise('error') }

    it "shouldn't delete merchant" do
      expect do
        expect(merchant_destroyer.call).to be_falsey
      end.to not_change(User, :count)
        .and not_change(Merchant, :count)
    end
  end
end
