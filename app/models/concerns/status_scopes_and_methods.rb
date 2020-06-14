module StatusScopesAndMethods
  extend ActiveSupport::Concern

  included do
    self::STATUSES.each do |status|
      scope status, -> { where(status: status) }
    end

    self::STATUSES.each do |status|
      define_method "#{status}?" do
        self.status == self.class::STATUS.send(status)
      end

      define_method "status_#{status}!" do
        self.status = self.class::STATUS.send(status)
        save!
      end
    end
  end
end
