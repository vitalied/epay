require 'rails_helper'

RSpec.describe DeleteOldTransactionsJob, type: :job do
  context '#perform_later' do
    it 'should have an enqueued job' do
      expect { DeleteOldTransactionsJob.perform_later }.to have_enqueued_job
    end
  end

  context '#perform' do
    let!(:transaction) { create :authorize_transaction, created_at: 2.hours.ago }
    let!(:other_transaction) { create :authorize_transaction }

    it 'should delete old transactions' do
      expect { DeleteOldTransactionsJob.perform_now }.to change(Transaction, :count).by(-1)
    end
  end
end
