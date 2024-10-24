class ApplicationController < ActionController::API
  rescue_from JWT::DecodeError, with: :handle_jwt_error
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  def authorize_owner(record)
    unless record.user == current_user
      json_response 403, 'You are not authorized to perform this action.'
    end
  end

  def json_response(status_code, message, data = {})
    render json: {
      status: {
        code: status_code,
        message: message
      },
      data: data
    }, status: status_code
  end

  private

    def handle_jwt_error(error)
      if error.message == 'Not enough or too many segments'
        render json: { status: { code: 401, message: 'JWT token is invalid or expired' }, data: { error_code: 100011 } }, status: :unauthorized
      else
        render json: { status: { code: 401, message: 'Invalid JWT token' }, data: { error_code: 100011 } }, status: :unauthorized
      end
    end
end
