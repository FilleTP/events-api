class CustomFailureApp < Devise::FailureApp
  def respond
    json_error_response
  end

  private

  def json_error_response
    error_message = warden_message || "Authentication failed"
    error_code = 100011
    error_message = "JWT token is invalid or expired. " + error_message
    Rails.logger.error "Warden Failure: #{error_message}"

    self.status = 401
    self.content_type = 'application/json'
    self.response_body = {
      status: {
        code: status,
        message: error_message
      },
      data: {
        error_code: error_code
      }
    }.to_json
  end
end
