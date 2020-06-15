require 'csv'

module Importer
  class Base < ApplicationService
    def initialize(file_name)
      @file_path = Rails.root.join('import', file_name)
      @error_rows = []
    end

    def call
      puts "---  Start importing #{self.class::SUBJECT}  ---"

      CSV.foreach(@file_path, headers: true) do |row|
        begin
          process_row(row)
        rescue => e
          @error_rows << row_error_text(row, e)
        end
      end

      puts "---  Import of #{self.class::SUBJECT} finished  ---"

      return if @error_rows.blank?

      puts 'Import errors:'

      @error_rows.each { |error| puts error }
    end
  end
end
