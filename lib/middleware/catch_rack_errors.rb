module Middleware
  class CatchRackErrors
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue JWT::DecodeError
        [
          401,
          { "Content-Type" => "application/json" },
          [
            {
              status: {
                code: 401,
                message: 'JWT token is invalid or expired.'
              },
              data: {
                error_code: 100011
              }
            }.to_json
          ]
        ]
      end
    end
  end
end
