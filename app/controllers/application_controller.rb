class ApplicationController < ActionController::Base
  include ExceptionHandling

  before_action :authenticate_user!
end
