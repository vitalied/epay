module Importer
  class Admins < Importer::Base
    SUBJECT = 'admin users'.freeze

    private

    def process_row(row)
      user_params = row.to_h.merge(admin: true)

      User.create!(user_params)
    end

    def row_error_text(row, e)
      "Admin user for the following email can't be created: #{row['email']}. Error: #{e.message}"
    end
  end
end
