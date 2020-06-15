class BaseController < ApplicationController
  before_action :perform_authorization
  after_action :verify_authorized

  private

  def perform_authorization
    authorize :merchant, :can?
  end
end
