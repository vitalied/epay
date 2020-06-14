require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }

  it { is_expected.to have_one :merchant }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it_behaves_like :validate_email, :email

  it 'should have a token' do
    expect(user.authentication_token).to be_present
  end

  it "shouldn't have admin role" do
    expect(user.admin?).to be_falsey
  end

  it 'should have admin role' do
    expect(admin_user.admin?).to be_truthy
  end
end
