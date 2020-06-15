module ExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::InvalidAuthenticityToken, with: :render_unauthorized

    def routing_error
      render_errors('Invalid URL or method.', :bad_request)
    end

    private

    def render_unauthorized
      render_errors(:Unauthorized, :unauthorized)
    end

    def render_errors(error, status = :unprocessable_entity)
      respond_to do |format|
        format.html do
          redirect_to root_path, alert: error
        end
        format.json do
          render json: { error: error }, status: status
        end
      end
    end
  end
end
