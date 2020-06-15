module ExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::InvalidAuthenticityToken, with: :render_unauthorized
    rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

    def routing_error
      render_errors('Invalid URL or method.', :bad_request)
    end

    private

    def render_unauthorized
      render_errors(:Unauthorized, :unauthorized)
    end

    def render_forbidden
      render_errors(:Forbidden, :forbidden)
    end

    def render_errors(error, status = :unprocessable_entity)
      respond_to do |format|
        format.html do
          path = current_user.present? ? merchant_root_path : root_path

          redirect_to path, alert: error
        end
        format.json do
          render json: { error: error }, status: status
        end
      end
    end
  end
end
