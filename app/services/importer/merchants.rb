module Importer
  class Merchants < Importer::Base
    SUBJECT = 'merchants'.freeze

    private

    def process_row(row)
      merchant_params = row.to_h

      merchant_creator = Admin::MerchantCreator.new(merchant_params)

      return if merchant_creator.call

      merchant = merchant_creator.merchant
      @error_rows << row_error_text(row, merchant.errors.to_a.join(', '))
    end

    def row_error_text(row, e)
      "Merchant for the following email can't be created: #{row['email']}. Error: #{e.try(:message) || e}"
    end
  end
end
