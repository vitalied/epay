require 'rails_helper'

feature 'Signing in' do
  let(:password) { '123456' }
  let(:user) { create :admin_user, password: password }

  scenario 'Signing in with correct credentials' do
    visit new_user_session_path

    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
    end
    click_button 'Sign In'

    expect(page).to have_content 'Signed in successfully.'
  end
end

feature 'Merchants page' do
  let(:user) { create :admin_user }
  let(:merchants_list) { create_list :merchant, 2 }
  let!(:merchant) { merchants_list.first }
  let!(:other_merchant) { merchants_list.last }

  before { login_as(user, scope: :user) }

  scenario 'Should list merchants list' do
    visit admin_merchants_path

    within first('table tbody tr') do
      expect(page).to have_xpath('td[1]', text: other_merchant.name)
      expect(page).to have_xpath('td[2]', text: other_merchant.email)
      expect(page).to have_xpath('td[3]', text: other_merchant.total_transaction_sum)
      expect(page).to have_xpath('td[4]', text: other_merchant.status)
    end

    within all('table tbody tr').last do
      expect(page).to have_xpath('td[1]', text: merchant.name)
      expect(page).to have_xpath('td[2]', text: merchant.email)
      expect(page).to have_xpath('td[3]', text: merchant.total_transaction_sum)
      expect(page).to have_xpath('td[4]', text: merchant.status)
    end
  end
end

feature 'Create Merchant page' do
  let(:user) { create :admin_user }
  let(:merchant) { build :merchant }

  before { login_as(user, scope: :user) }

  scenario 'Should successfully create merchant' do
    visit new_admin_merchant_path

    expect(page).to have_content 'New Merchant'

    within('.new_merchant') do
      fill_in('Name', with: merchant.name)
      fill_in('Description', with: merchant.description)
      fill_in('Email', with: merchant.email)
      first('.form-check-input').click
      click_button 'Save'
    end

    expect(page).to have_content 'Merchant was successfully created.'
  end

  scenario "Shouldn't create merchant" do
    visit new_admin_merchant_path

    expect(page).to have_content 'New Merchant'

    within('.new_merchant') do
      first('.form-check-input').click
      click_button 'Save'
    end

    expect(page).to have_content "Email can't be blank"
  end
end

feature 'Merchant details page' do
  let(:user) { create :admin_user }
  let(:merchant) { create :merchant }
  let!(:transaction) { create :authorize_transaction, merchant: merchant }

  before { login_as(user, scope: :user) }

  scenario 'Should show merchant details' do
    visit admin_merchant_path(merchant)

    expect(page).to have_content 'Merchant details'

    within first('table tbody tr') do
      expect(page).to have_xpath('td[1]', text: merchant.name)
      expect(page).to have_xpath('td[2]', text: merchant.email)
      expect(page).to have_xpath('td[3]', text: merchant.total_transaction_sum)
      expect(page).to have_xpath('td[4]', text: merchant.status)
    end

    within all('table tbody tr').last do
      expect(page).to have_xpath('td[1]', text: transaction.type)
      expect(page).to have_xpath('td[2]', text: merchant.name)
      expect(page).to have_xpath('td[3]', text: '-')
      expect(page).to have_xpath('td[4]', text: transaction.uuid)
      expect(page).to have_xpath('td[5]', text: transaction.amount)
      expect(page).to have_xpath('td[6]', text: transaction.status)
      expect(page).to have_xpath('td[7]', text: transaction.customer_email)
      expect(page).to have_xpath('td[8]', text: transaction.customer_phone)
    end
  end
end

feature 'Edit Merchant page' do
  let(:user) { create :admin_user }
  let(:merchant) { create :merchant }
  let!(:transaction) { create :authorize_transaction, merchant: merchant }
  let(:new_name) { Faker::Company.unique.name }

  before { login_as(user, scope: :user) }

  scenario 'Should successfully update merchant' do
    visit edit_admin_merchant_path(merchant)

    expect(page).to have_content 'Edit Merchant'

    within('.edit_merchant') do
      fill_in('Name', with: new_name)
      click_button 'Save'
    end

    expect(page).to have_content 'Merchant was successfully updated.'
  end

  scenario "Shouldn't update merchant" do
    visit edit_admin_merchant_path(merchant)

    expect(page).to have_content 'Edit Merchant'

    within('.edit_merchant') do
      fill_in('Name', with: nil)
      click_button 'Save'
    end

    expect(page).to have_content "Name can't be blank"
  end
end
