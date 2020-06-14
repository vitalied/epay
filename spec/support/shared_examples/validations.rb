shared_examples :validate_email do |attr|
  context attr.to_s do
    let(:allowed_emails) { %w[info@u.edu info@c.u.edu] }
    let(:disallowed_emails) { %w[info] }

    it { is_expected.to allow_value(*allowed_emails).for(attr) }
    it { is_expected.not_to allow_value(*disallowed_emails).for(attr).with_message(:invalid) }
  end
end
