class AdminPolicy < Struct.new(:user, :admin)
  def can?
    user.admin?
  end
end
