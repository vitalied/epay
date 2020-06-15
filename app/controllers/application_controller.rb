class ApplicationController < ActionController::Base
  include Pundit
  include ExceptionHandling

  before_action :authenticate_user!
end
