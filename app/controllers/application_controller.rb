class ApplicationController < ActionController::Base
  include Pundit
  include ExceptionHandling

  before_action :authenticate_user!

  private

  def current_merchant
    current_user&.merchant
  end
end
