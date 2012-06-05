module GitHttp
  class Middleware
    def initialize(app, config = {})
      @githttp = GitHttp::App.new(config)
      @app = app
    end
    
    def call(env)
      response = @githttp.call(env)
      if response[0] == 404
        @app.call(env)
      else
        response
      end
    end
  end
end