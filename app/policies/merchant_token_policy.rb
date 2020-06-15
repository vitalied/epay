class MerchantTokenPolicy < Struct.new(:user, :merchant)
  def can?
    !user.admin? && user.merchant&.active?
  end
end
