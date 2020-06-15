class MerchantPolicy < Struct.new(:user, :merchant)
  def can?
    !user.admin?
  end
end
