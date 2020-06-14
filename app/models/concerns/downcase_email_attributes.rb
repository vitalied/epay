module DowncaseEmailAttributes
  extend ActiveSupport::Concern

  included do
    before_validation :downcase_email_attributes

    private

    def downcase_email_attributes
      attribute_names.select { |attr| attr.match(/email/i) }.each do |attr|
        send(attr).downcase! if send(attr).present?
      end
    end
  end
end
