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
              message: 'JWT token is invalid or expired',
              error_code: 100011
            }.to_json
          ]
        ]
      end
    end
  end
end
